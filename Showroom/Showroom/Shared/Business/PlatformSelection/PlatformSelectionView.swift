import UIKit

protocol PlatformSelectionViewDelegate: class {
    func platformSelectionViewDidTapPolish(view: PlatformSelectionView)
    func platformSelectionViewDidTapGerman(view: PlatformSelectionView)
}

class PlatformSelectionView: UIView {
    private let topButtonInset: CGFloat
    private let buttonsSpacing: CGFloat = 23
    
    private let backgroundImageView = UIImageView()
    private let polishButton = PlatformButton(flagAndTextImage: UIImage(asset: .Flag_4_pl))
    private let germanButton = PlatformButton(flagAndTextImage: UIImage(asset: .Flag_4_de))

    
    weak var delegate: PlatformSelectionViewDelegate?
    
    init() {
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            backgroundImageView.image = UIImage(asset: .Platform_4)
            topButtonInset = 150
        case .iPhone5:
            backgroundImageView.image = UIImage(asset: .Platform_5)
            topButtonInset = 200
        case .iPhone6:
            backgroundImageView.image = UIImage(asset: .Platform_6)
            topButtonInset = 240
        case .iPhone6Plus:
            backgroundImageView.image = UIImage(asset: .Platform_6p)
            topButtonInset = 280
        default:
            backgroundImageView.image = UIImage(asset: .Platform_6)
            topButtonInset = 240
        }
        
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        polishButton.addTarget(self, action: #selector(PlatformSelectionView.didTapPolishButton(_:)), forControlEvents: .TouchUpInside)
        
        germanButton.addTarget(self, action: #selector(PlatformSelectionView.didTapGermanButton(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(backgroundImageView)
        addSubview(polishButton)
        addSubview(germanButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapPolishButton(sender: UIButton!) {
        delegate?.platformSelectionViewDidTapPolish(self)
    }
    
    func didTapGermanButton(sender: UIButton!) {
        delegate?.platformSelectionViewDidTapGerman(self)
    }
    
    func configureCustomConstraints() {
        backgroundImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        polishButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topButtonInset)
            make.width.equalTo(162)
            make.height.equalTo(46)
        }
        germanButton.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(polishButton.snp_bottom).offset(buttonsSpacing)
            make.width.equalTo(162)
            make.height.equalTo(46)
        }
    }
}