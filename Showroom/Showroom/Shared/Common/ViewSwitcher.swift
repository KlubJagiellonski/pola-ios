import Foundation
import UIKit
import SnapKit

typealias ErrorText = String
typealias ErrorImage = UIImage

enum ViewSwitcherState {
    case Success
    case Error
    case ModalError
    case Loading
    case Empty
}

protocol ViewSwitcherDataSource: class {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?)
}

protocol ViewSwitcherDelegate: class {
    func viewSwitcherDidTapRetry(view: ViewSwitcher)
}

class ViewSwitcher: UIView {
    private let dimViewAlpha: CGFloat = 0.7
    var animationDuration = 0.3
    private var animationEndBlock: (() -> ())?
    private var animatingToState: ViewSwitcherState?
    
    let successView: UIView
    lazy var errorView: ErrorView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show error view") }
        let errorInfo = dataSource.viewSwitcherWantsErrorInfo(self)
        let errorView = ErrorView(errorText: errorInfo.0, errorImage: errorInfo.1)
        errorView.backgroundView.backgroundColor = UIColor(named: .Gray)
        errorView.viewSwitcher = self
        return errorView
    }()
    lazy var modalErrorView: ErrorView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show error view") }
        let errorInfo = dataSource.viewSwitcherWantsErrorInfo(self)
        let errorView = ErrorView(errorText: errorInfo.0, errorImage: errorInfo.1)
        errorView.backgroundView.backgroundColor = UIColor(named: .Dim).colorWithAlphaComponent(self.dimViewAlpha)
        errorView.viewSwitcher = self
        return errorView
    }()
    lazy var loadingView: LoadingView = LoadingView()
    lazy var emptyView: EmptyView = EmptyView()
    
    weak var switcherDataSource: ViewSwitcherDataSource?
    weak var switcherDelegate: ViewSwitcherDelegate?
    
    var switcherState: ViewSwitcherState {
        didSet {
            guard oldValue != switcherState else { return }
            
            if let animatingToState = animatingToState {
                animationEndBlock = { [weak self] in
                    self?.animateToNewState(fromState: animatingToState)
                }
                return
            }
            animateToNewState(fromState: oldValue)
        }
    }
    
    var currentView: UIView {
        return view(forState: switcherState)
    }
    
    init(successView: UIView, initialState: ViewSwitcherState = .Loading) {
        self.successView = successView
        switcherState = initialState
        super.init(frame: CGRectZero)
        
        addSubview(currentView)
        configureConstraints(forSubview: currentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateToNewState(fromState fromState: ViewSwitcherState) {
        if fromState == switcherState {
            return
        }
        
        let newView = view(forState: switcherState)
        if newView.superview == nil {
            addSubview(newView)
            configureConstraints(forSubview: newView)
        }
        
        animatingToState = switcherState
        
        let commonCompletion = { [weak self] (success: Bool) in
            self?.animatingToState = nil
            self?.animationEndBlock?()
            self?.animationEndBlock = nil
        }
        
        if switcherState == .ModalError || fromState == .ModalError {
            modalErrorView.alpha = switcherState == .ModalError ? 0 : 1
            UIView.animateWithDuration(animationDuration, animations: {
                self.modalErrorView.alpha = self.switcherState == .ModalError ? 1 : 0
            }, completion: commonCompletion)
        } else {
            let oldView = view(forState: fromState)
            UIView.transitionFromView(oldView, toView: newView, duration: animationDuration, options: [.TransitionCrossDissolve, .ShowHideTransitionViews]) { success in
                oldView.snp_removeConstraints()
                oldView.removeFromSuperview()
                commonCompletion(success)
            }
        }
    }
    
    private func configureConstraints(forSubview view: UIView) {
        view.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func view(forState state: ViewSwitcherState) -> UIView {
        switch state {
        case .Success:
            return successView
        case .Error:
            return errorView
        case .ModalError:
            return modalErrorView
        case .Loading:
            return loadingView
        case .Empty:
            return emptyView
        }
    }
}

class ErrorView: UIView {
    private let backgroundView =  UIView()
    private let imageView: UIImageView?
    private let textLabel = UILabel()
    private let retryButton = UIButton()
    private let contentView = UIView()
    
    weak var viewSwitcher: ViewSwitcher?
    
    init(errorText: String, errorImage: UIImage?) {
        imageView = errorImage == nil ? nil : UIImageView(image: errorImage!)
        super.init(frame: CGRectZero)
        
        textLabel.text = errorText
        textLabel.font = UIFont(fontType: .Normal)
        textLabel.textColor = UIColor(named: .Black)
        textLabel.numberOfLines = 0
        
        retryButton.applyBigCircleStyle()
        retryButton.setImage(UIImage(asset: .Refresh), forState: .Normal)
        retryButton.addTarget(self, action: #selector(ErrorView.didTapRetry), forControlEvents: .TouchUpInside)
        
        addSubview(backgroundView)
        if let imageView = imageView {
            contentView.addSubview(imageView)
        }
        contentView.addSubview(textLabel)
        contentView.addSubview(retryButton)
        
        addSubview(contentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapRetry() {
        viewSwitcher?.switcherDelegate?.viewSwitcherDidTapRetry(viewSwitcher!)
    }
    
    private func configureCustomConstraints() {
        backgroundView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        if let imageView = imageView {
            imageView.snp_makeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        textLabel.snp_makeConstraints { make in
            if let imageView = imageView {
                make.top.equalTo(imageView.snp_bottom).offset(63)
            } else {
                make.top.equalToSuperview()
            }
            make.width.equalTo(194)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        retryButton.snp_makeConstraints { make in
            make.top.equalTo(textLabel.snp_bottom).offset(24)
            make.width.equalTo(Dimensions.bigCircleButtonDiameter)
            make.height.equalTo(retryButton.snp_width)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

class LoadingView: UIView {
    private let indicatorView = LoadingIndicator()
    private var contentEdgeConstraint: Constraint?
    var contentOffset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            contentEdgeConstraint?.updateOffset(contentOffset)
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        addSubview(indicatorView)
        
        indicatorView.snp_makeConstraints { make in
            contentEdgeConstraint = make.center.equalToSuperview().constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview != nil ? indicatorView.startAnimation() : indicatorView.stopAnimation()
    }
}

class EmptyView: UIView {
    
}