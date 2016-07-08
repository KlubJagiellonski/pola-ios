import Foundation
import UIKit

protocol SizeChartViewControllerDelegate {
    func sizeChartDidTapBack(viewController: SizeChartViewController)
}

class SizeChartViewController: UIViewController, SizeChartViewDelegate {
    let sizes: [ProductDetailsSize]
    var castView: SizeChartView { return view as! SizeChartView }
    var delegate: SizeChartViewControllerDelegate?
    var viewContentInset: UIEdgeInsets?
    
    init(sizes: [ProductDetailsSize]) {
        self.sizes = sizes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SizeChartView(sizes: sizes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.contentInset = viewContentInset
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        castView.updateHeaderBackground(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        castView.updateHeaderBackground(false, animationDuration: 0.3)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        castView.updateHeaderBackground(true)
    }
    
    func sizeChartDidTapBack(view: SizeChartView) {
        delegate?.sizeChartDidTapBack(self)
    }
    
    //todo remove when api will not be mocked
    func createTestSizes() -> [ProductDetailsSize] {
        return [
            ProductDetailsSize(id: 1, name: "XXS", colors: [], measurements: [
                "długość całkowita": "96",
                "długość nogawki wewnętrzna": "96",
                "szerokość nogawki w udzie": "96",
                "szerokość nogawki w łydce": "96",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "XS", colors: [], measurements: [
                "długość całkowita": "98",
                "długość nogawki wewnętrzna": "96",
                "szerokość nogawki w udzie": "96",
                "szerokość nogawki w łydce": "96",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "S", colors: [], measurements: [
                "długość całkowita": "100",
                "długość nogawki wewnętrzna": "100",
                "szerokość nogawki w udzie": "100",
                "szerokość nogawki w łydce": "100",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "M", colors: [], measurements: [
                "długość całkowita": "100",
                "długość nogawki wewnętrzna": "100",
                "szerokość nogawki w udzie": "100",
                "szerokość nogawki w łydce": "100",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "L", colors: [], measurements: [
                "długość całkowita": "100",
                "długość nogawki wewnętrzna": "100",
                "szerokość nogawki w udzie": "100",
                "szerokość nogawki w łydce": "100",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "XL", colors: [], measurements: [
                "długość całkowita": "100",
                "długość nogawki wewnętrzna": "100",
                "szerokość nogawki w udzie": "100",
                "szerokość nogawki w łydce": "100",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ]),
            ProductDetailsSize(id: 1, name: "XXL", colors: [], measurements: [
                "długość całkowita": "100",
                "długość nogawki wewnętrzna": "100",
                "szerokość nogawki w udzie": "100",
                "szerokość nogawki w łydce": "100",
                "szerokość nogawki w biodrach": "96",
                "szerokość nogawki w pasie": "96",
                "długość nogawki zewnętrzna": "96",
                "szerokość w biodrach": "96",
                "szerokość w rękach": "96",
                "szerokość w szyi": "96",
                ])
        ]
    }
}
