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
    case ModalLoading
    case Empty
    
    func isModal() -> Bool {
        return self == .ModalError || self == .ModalLoading
    }
}

enum ViewSwitcherContainerType {
    case Normal
    case Modal
}

protocol ViewSwitcherDataSource: class {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?)
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView?
}

protocol ViewSwitcherDelegate: class {
    func viewSwitcherDidTapRetry(view: ViewSwitcher)
}

class ViewSwitcher: UIView {
    private static let dimViewAlpha: CGFloat = 0.7
    var animationDuration = 0.3
    private var animationEndBlock: (() -> ())?
    private var animatingToState: ViewSwitcherState?
    
    let successView: UIView
    lazy var errorView: ErrorView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show error view") }
        let errorInfo = dataSource.viewSwitcherWantsErrorInfo(self)
        let errorView = ErrorView(containerType: .Normal, errorText: errorInfo.0, errorImage: errorInfo.1)
        errorView.viewSwitcher = self
        return errorView
    }()
    lazy var modalErrorView: ErrorView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show error view") }
        let errorInfo = dataSource.viewSwitcherWantsErrorInfo(self)
        let errorView = ErrorView(containerType: .Modal, errorText: errorInfo.0, errorImage: errorInfo.1)
        errorView.viewSwitcher = self
        return errorView
    }()
    lazy var loadingView: LoadingView = LoadingView(containerType: .Normal)
    lazy var modalLoadingView: LoadingView = LoadingView(containerType: .Modal)
    lazy var emptyView: UIView = { [unowned self] in
        guard let dataSource = self.switcherDataSource else { fatalError("You must set data source if you want to show empty view") }
        guard let emptyView = dataSource.viewSwitcherWantsEmptyView(self) else { fatalError("You must return non null for method viewSwitcherWantsEmptyView if you want to show empty view") }
        return emptyView
    }()
    
    weak var switcherDataSource: ViewSwitcherDataSource?
    weak var switcherDelegate: ViewSwitcherDelegate?
    
    private(set) var switcherState: ViewSwitcherState
    
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
    
    func changeSwitcherState(switcherState: ViewSwitcherState, animated: Bool = true) {
        let oldValue = self.switcherState
        self.switcherState = switcherState
        
        guard oldValue != switcherState else { return }
        
        if let animatingToState = animatingToState {
            animationEndBlock = { [weak self] in
                self?.animateToNewState(fromState: animatingToState, animated: animated)
            }
            return
        }
        animateToNewState(fromState: oldValue, animated: animated)
    }
    
    private func animateToNewState(fromState fromState: ViewSwitcherState, animated: Bool) {
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
        
        let oldView = view(forState: fromState)
        
        if switcherState.isModal() || fromState.isModal() {
            switchModalView(fromView: oldView, toView: newView, isNewStateModal: switcherState.isModal(), isOldStateModal: fromState.isModal(), animated: animated, completion: commonCompletion)
        } else {
            switchView(fromView: oldView, toView: newView, animated: animated, completion: commonCompletion)
        }
    }
    
    private func switchModalView(fromView fromView: UIView, toView: UIView, isNewStateModal: Bool, isOldStateModal: Bool, animated: Bool, completion: Bool -> ()) {
        if isNewStateModal {
            toView.alpha = 0
            toView.hidden = false
            bringSubviewToFront(toView)
        }
        if isOldStateModal {
            fromView.alpha = 1
            fromView.hidden = false
        }
        
        //it is for situation when there is existing modal and not modal view below it. Then when we want to change it to different view we have to transition between those views
        if !isNewStateModal && toView != subviews[0] {
            let existingView = subviews[0]
            switchView(fromView: existingView, toView: toView, animated: animated, completion: nil)
        }
        
        UIView.animateWithDuration(animated ? animationDuration : 0, animations: {
            if isNewStateModal { toView.alpha = 1 }
            if isOldStateModal { fromView.alpha = 0 }
        }) { success in
            if isOldStateModal && fromView.superview != nil {
                fromView.snp_removeConstraints()
                fromView.removeFromSuperview()
            }
            completion(success)
        }
    }
    
    private func switchView(fromView fromView: UIView, toView: UIView, animated: Bool, completion: (Bool -> ())?) {
        UIView.transitionFromView(fromView, toView: toView, duration: animated ? animationDuration: 0, options: [.TransitionCrossDissolve, .ShowHideTransitionViews]) { success in
            if fromView.superview != nil {
                fromView.snp_removeConstraints()
                fromView.removeFromSuperview()
            }
            completion?(success)
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
        case .ModalLoading:
            return modalLoadingView
        case .Empty:
            return emptyView
        }
    }
}

final class ErrorView: UIView {
    private let backgroundView = UIView()
    private let imageView: UIImageView?
    private let textLabel = UILabel()
    private let retryButton = UIButton()
    private let contentView = UIView()
    
    weak var viewSwitcher: ViewSwitcher?
    
    init(containerType: ViewSwitcherContainerType, errorText: String, errorImage: UIImage?) {
        imageView = errorImage == nil ? nil : UIImageView(image: errorImage!)
        super.init(frame: CGRectZero)
        
        switch containerType {
        case .Normal:
            textLabel.font = UIFont(fontType: .Normal)
            backgroundView.backgroundColor = UIColor(named: .Gray)
        case .Modal:
            textLabel.font = UIFont(fontType: .ErrorBold)
            backgroundView.backgroundColor = UIColor(named: .Dim).colorWithAlphaComponent(ViewSwitcher.dimViewAlpha)
        }
        
        textLabel.text = errorText
        textLabel.textColor = UIColor(named: .Black)
        textLabel.textAlignment = .Center
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

final class LoadingView: UIView {
    private let indicatorView = LoadingIndicator()
    private var contentEdgeConstraint: Constraint?
    var contentOffset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            contentEdgeConstraint?.updateOffset(contentOffset)
        }
    }
    
    init(containerType: ViewSwitcherContainerType) {
        super.init(frame: CGRectZero)
        
        if containerType == .Modal {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(named: .Dim).colorWithAlphaComponent(ViewSwitcher.dimViewAlpha)
            addSubview(backgroundView)
            
            backgroundView.snp_makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        addSubview(indicatorView)
        
        indicatorView.snp_makeConstraints { make in
            contentEdgeConstraint = make.center.equalToSuperview().constraint
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        window != nil ? indicatorView.startAnimation() : indicatorView.stopAnimation()
    }
}