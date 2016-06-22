import Foundation
import UIKit

typealias ErrorText = String
typealias ErrorImage = UIImage

enum ViewSwitcherState {
    case Success
    case Error
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
    private let animationDuration = 0.2
    private var animationEndBlock: (() -> ())?
    private var animationInProgress = false
    
    let successView: UIView
    lazy var errorView: ErrorView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show error view") }
        let errorInfo = dataSource.viewSwitcherWantsErrorInfo(self)
        let errorView = ErrorView(errorText: errorInfo.0, errorImage: errorInfo.1)
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
            
            if animationInProgress {
                animationEndBlock = { [weak self] in
                    self?.animateToNewState()
                }
                return
            }
            animateToNewState()
        }
    }
    
    var currentView: UIView {
        return view(forState: switcherState)
    }
    
    init(successView: UIView, defaultState: ViewSwitcherState = .Loading) {
        self.successView = successView
        switcherState = defaultState
        super.init(frame: CGRectZero)
        
        addSubview(currentView)
        configureConstraints(forSubview: currentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animateToNewState() {
        let newView = view(forState: switcherState)
        addSubview(newView)
        configureConstraints(forSubview: newView)
        
        let oldView = subviews[0]
        if oldView == newView {
            return
        }
        
        animationInProgress = true
        UIView.transitionFromView(oldView, toView: newView, duration: animationDuration, options: [.TransitionCrossDissolve, .ShowHideTransitionViews]) { [weak self] _ in
            oldView.snp_removeConstraints()
            oldView.removeFromSuperview()
            self?.animationInProgress = false
            self?.animationEndBlock?()
            self?.animationEndBlock = nil
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
        case .Loading:
            return loadingView
        case .Empty:
            return emptyView
        }
    }
}

class ErrorView: UIView {
    private let imageView: UIImageView?
    private let textLabel = UILabel()
    private let retryButton = UIButton()
    private let contentView = UIView()
    
    weak var viewSwitcher: ViewSwitcher?
    
    init(errorText: String, errorImage: UIImage?) {
        imageView = errorImage == nil ? nil : UIImageView(image: errorImage!)
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .Gray)
        
        textLabel.text = errorText
        textLabel.font = UIFont(fontType: .Normal)
        textLabel.textColor = UIColor(named: .Black)
        textLabel.numberOfLines = 0
        
        retryButton.applyBigCircleStyle()
        retryButton.setImage(UIImage(asset: .Refresh), forState: .Normal)
        retryButton.addTarget(self, action: #selector(ErrorView.didTapRetry), forControlEvents: .TouchUpInside)
        
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
    
    init() {
        super.init(frame: CGRectZero)
        
        addSubview(indicatorView)
     
        indicatorView.snp_makeConstraints { make in
            make.center.equalToSuperview()
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