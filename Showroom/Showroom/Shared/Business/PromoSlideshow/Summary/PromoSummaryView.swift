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
    private let linksView: PromoSummaryLinksView?
    
    weak var delegate: PromoSummaryViewDelegate?
    
    init(promoSlideshow: PromoSlideshow) {
        if promoSlideshow.links.isEmpty {
            playerView = PromoSummaryPlayerView(playlistItems: promoSlideshow.playlist, withRepeatButton: true)
            linksView = nil
        } else {
            playerView = PromoSummaryPlayerView(playlistItems: promoSlideshow.playlist, withRepeatButton: false)
            linksView = PromoSummaryLinksView(links: promoSlideshow.links)
        }
        
        super.init(frame: CGRectZero)
        
        playerView.promoSummaryView = self
        addSubview(playerView)
        
        if let linksView = linksView {
            linksView.promoSummaryView = self
            addSubview(linksView)
        }
        
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
    
    func didTapRepeatButton() {
        delegate?.promoSummaryDidTapRepeat(self)
    }
    
    private func configureCustomConstraints() {
        playerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            if linksView == nil {
                make.bottom.equalToSuperview()
            } else {
                make.height.equalTo(playerView.snp_width).dividedBy(UIDevice.currentDevice().screenType == .iPhone4 ? 0.9 : Dimensions.videoImageRatio)
            }
        }
        
        linksView?.snp_makeConstraints { make in
            make.top.equalTo(playerView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
