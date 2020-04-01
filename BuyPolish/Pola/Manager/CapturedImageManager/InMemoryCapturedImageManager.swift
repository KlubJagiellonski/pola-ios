import UIKit

final class InMemoryCapturedImageManager: CapturedImageManager {
    private var dataArray = [Data]()
    
    func addImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            return
        }
        dataArray.append(data)
    }
    
    func retrieveImagesData() -> [Data] {
        dataArray
    }
    
    func removeImages(){
        dataArray.removeAll()
    }
    
    var imagesCount: Int {
        dataArray.count
    }
    
}
