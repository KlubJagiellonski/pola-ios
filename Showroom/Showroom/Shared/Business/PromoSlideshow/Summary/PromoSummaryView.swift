import Foundation

protocol PromoSummaryViewDelegate: class {
    func promoSummary(promoSummary: PromoSummaryView, didTapPlayForVideo video: PromoSlideshowPlaylistItem)
    func promoSummaryDidAutoPlay(promoSummary: PromoSummaryView, forVideo video: PromoSlideshowPlaylistItem)
    func promoSummaryDidTapRepeat(promoSummary: PromoSummaryView)
    func promoSummary(promoSummary: PromoSummaryView, didTapLink link: PromoSlideshowLink)
    func promoSummaryDidTapNext(promoSummary: PromoSummaryView, withCurrentVideo video: PromoSlideshowPlaylistItem)
    func promoSummaryDidTapPrevious(promoSummary: PromoSummaryView, withCurrentVideo video: PromoSlideshowPlaylistItem)
}

final class PromoSummaryView: UIView {
    private let playerView: PromoSummaryPlayerView
    private let repeatButton = UIButton()
    private let separatorView = UIView()
    private let linksView: PromoSummaryLinksView
    
    weak var delegate: PromoSummaryViewDelegate?
    
    init(promoSlideshow: PromoSlideshow) {
        playerView = PromoSummaryPlayerView(playlistItems: promoSlideshow.playlist)
        linksView = PromoSummaryLinksView(links: promoSlideshow.links)
        super.init(frame: CGRectZero)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        let repeatTitle = tr(.PromoVideoSummaryRepeat)
        repeatButton.addTarget(self, action: #selector(PromoSummaryView.didTapRepeatButton), forControlEvents: .TouchUpInside)
        repeatButton.setImage(UIImage(asset: .Repeat), forState: .Normal)
        repeatButton.setTitle(repeatTitle, forState: .Normal)
        repeatButton.applyBlackPlainBoldStyle()
        
        playerView.promoSummaryView = self
        linksView.promoSummaryView = self
        
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
    
    func didTapNext(withCurrentVideo video: PromoSlideshowPlaylistItem) {
        delegate?.promoSummaryDidTapNext(self, withCurrentVideo: video)
    }
    
    func didTapBack(withCurrentVideo video: PromoSlideshowPlaylistItem) {
        delegate?.promoSummaryDidTapPrevious(self, withCurrentVideo: video)
    }
    
    func didTap(playForVideo video: PromoSlideshowPlaylistItem) {
        delegate?.promoSummary(self, didTapPlayForVideo: video)
    }
    
    func didTap(link link: PromoSlideshowLink) {
        delegate?.promoSummary(self, didTapLink: link)
    }
    
    func didAutoPlay(forVideo video: PromoSlideshowPlaylistItem) {
        delegate?.promoSummaryDidAutoPlay(self, forVideo: video)
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
