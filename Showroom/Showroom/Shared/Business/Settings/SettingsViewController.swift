import Foundation
import UIKit

class SettingsViewController: UIViewController, ProductSizeViewControllerDelegate, ProductColorViewControllerDelegate {
    let productActionHeight = CGFloat(216)
    
    let sizeButton = UIButton()
    let colorButton = UIButton()
    
    let dropUpAnimator: DropUpActionAnimator
    let resolver: DiResolver
    
    init(resolver: DiResolver) {
        self.resolver = resolver
        dropUpAnimator = DropUpActionAnimator(height: productActionHeight)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizeButton.setTitle("Product Size", forState: .Normal)
        sizeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeButton.addTarget(self, action: #selector(SettingsViewController.sizeButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(sizeButton)
        
        colorButton.setTitle("Product Color", forState: .Normal)
        colorButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        colorButton.addTarget(self, action: #selector(SettingsViewController.colorButtonPressed(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(colorButton)
        
        configureCustomConstraints()
    }
    
    func sizeButtonPressed(sender: UIButton!) {
        let productSizeVC = resolver.resolve(ProductSizeViewController.self)
        productSizeVC.delegate = self
        dropUpAnimator.presentViewController(productSizeVC, presentingVC: self)
    }
    
    func colorButtonPressed(sender: UIButton) {
        let productColorVC = resolver.resolve(ProductColorViewController.self)
        productColorVC.delegate = self
        dropUpAnimator.presentViewController(productColorVC, presentingVC: self)
    }
    
    func productSize(viewController: ProductSizeViewController, didChangeSize size: String) {
        print("did change product size: \(size)")
        dropUpAnimator.dismissViewController(presentingViewController: self)
    }

    func productSizeDidTapSizes(viewController: ProductSizeViewController) {
        print("did tap sizes button")
    }
    
    func productColor(viewController viewController: ProductColorViewController, didChangeColor color: ProductColor) {
        print("did change product color: \(color.name)")
        dropUpAnimator.dismissViewController(presentingViewController: self)
    }
    
    func configureCustomConstraints() {
        sizeButton.snp_makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        colorButton.snp_makeConstraints { make in
            make.top.equalTo(sizeButton.snp_bottom)
            make.centerX.equalToSuperview()
        }
    }
}