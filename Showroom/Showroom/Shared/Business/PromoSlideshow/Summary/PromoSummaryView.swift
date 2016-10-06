import Foundation

protocol PromoSummaryViewDelegate: class {
    func promoSummary(promoSummary: PromoSummaryView, didTapPlayForVideo video: PromoSlideshowOtherVideo)
    func promoSummaryDidTapRepeat(promoSummary: PromoSummaryView)
    func promoSummary(promoSummary: PromoSummaryView, didTapLink link: PromoSlideshowLink)
}

final class PromoSummaryView: UIView {
    private let playerRatio: CGFloat = 0.84
    
    private let playerView: PromoSummaryPlayerView
    private let repeatButton = UIButton()
    private let separatorView = UIView()
    private let linksView: PromoSummaryLinksView
    
    weak var delegate: PromoSummaryViewDelegate?
    
    init(promoSlideshow: PromoSlideshow) {
        playerView = PromoSummaryPlayerView(otherVideos: promoSlideshow.otherVideos)
        linksView = PromoSummaryLinksView(links: promoSlideshow.links)
        super.init(frame: CGRectZero)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        let repeatTitle = promoSlideshow.otherVideos.count > 1 ? tr(.PromoVideoSummaryRepeatPrevious) : tr(.PromoVideoSummaryRepeat)
        repeatButton.addTarget(self, action: #selector(PromoSummaryView.didTapRepeatButton), forControlEvents: .TouchUpInside)
        repeatButton.setImage(UIImage(asset: .Repeat), forState: .Normal)
        repeatButton.setTitle(repeatTitle, forState: .Normal)
        repeatButton.applyBlackPlainBoldStyle()
        
        playerView.promoSummaryView = self
        
        addSubview(playerView)
        addSubview(repeatButton)
        addSubview(separatorView)
        addSubview(linksView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startActions() {
        playerView.startPlayAnimation()
    }
    
    func stopActions() {
        playerView.stopPlayAnimation()
    }
    
    func didTap(playForVideo video: PromoSlideshowOtherVideo) {
        delegate?.promoSummary(self, didTapPlayForVideo: video)
    }
    
    func didTap(link link: PromoSlideshowLink) {
        delegate?.promoSummary(self, didTapLink: link)
    }
    
    @objc private func didTapRepeatButton() {
        delegate?.promoSummaryDidTapRepeat(self)
    }
    
    private func configureCustomConstraints() {
        playerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(playerView.snp_width).dividedBy(UIDevice.currentDevice().screenType == .iPhone4 ? 0.9 : 0.84)
        }
        
        repeatButton.snp_makeConstraints { make in
            make.top.equalTo(playerView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(UIDevice.currentDevice().screenType == .iPhone4 ? 40 : 46)
        }
        
        separatorView.snp_makeConstraints { make in
            make.top.equalTo(repeatButton.snp_bottom)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        linksView.snp_makeConstraints { make in
            make.top.equalTo(separatorView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
