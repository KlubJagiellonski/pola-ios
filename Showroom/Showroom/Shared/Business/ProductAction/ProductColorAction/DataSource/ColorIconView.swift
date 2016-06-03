import UIKit

enum ColorIconState {
    case Unknown
    case SetColor(UIColor)
    case SetImage(UIImage)
    case WaitingForResponse
    case ResponseFailed
}

class ColorIconView: UIImageView {
    static let borderWidth: CGFloat = 1
    static let borderColor = UIColor(named: .Manatee).CGColor
    
    private var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    private var state: ColorIconState = .Unknown {
        didSet {
            switch state {
            case .Unknown: break
            case .SetColor(let color):
                self.image = nil
                self.backgroundColor = color
                self.hidden = false
                spinner.stopAnimating()
                
            case .SetImage(let image):
                self.image = image
                self.hidden = false
                spinner.stopAnimating()
                
            case .WaitingForResponse:
                self.backgroundColor = nil
                self.image = nil
                self.hidden = false
                spinner.hidden = false
                spinner.startAnimating()
                
            case .ResponseFailed:
                spinner.stopAnimating()
                self.hidden = true
            }
        }
    }
    
    init() {
        super.init(image: nil)
        layer.borderColor = ColorIconView.borderColor
        layer.borderWidth = ColorIconView.borderWidth
        
        spinner.color = UIColor(named: .DarkGray)
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setColorRepresentation(colorRepresentation: ColorRepresentation) {
        switch colorRepresentation {
        case .Color(let color):
            state = .SetColor(color)
        case .ImageUrl(let url):
            state = .WaitingForResponse
            self.loadImageFromUrl(url,
                success: { image in
                    self.state = .SetImage(image)
                }, failure: { _ in
                    self.state = .ResponseFailed
            })
        }
    }
    
    func configureCustomConstraints() {
        spinner.snp_makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
