import Foundation
import Combine
import UIKit
import CoreData


class ImagesData: NSManagedObject {
    static let entityName = "ImagesData"
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    static let imageCache = NSCache<NSString, UIImage>()
    private var cancellable: AnyCancellable?
    private let url: String
    private let dataController: DataController
    private let imageCoreData = NSFetchRequest<ImagesData>(entityName: ImagesData.entityName)
    
    init(url: String, dataController: DataController) {
        self.url = url
        self.dataController = dataController
    }
    
    func load() {
        let viewContext = dataController.container.viewContext
        imageCoreData.predicate = NSPredicate(format: "link = %@", url)
        if let result = try? viewContext.fetch(imageCoreData),
           !result.isEmpty {
            DispatchQueue.main.async {
                self.image = UIImage(data: result[0].data!)
            }
            return
        }
        
        guard let url = URL(string: url) else {
            return
        }
        print(url)
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { image -> UIImage? in
                let object = ImagesData(context: self.dataController.container.viewContext)
                object.id = UUID()
                object.link = self.url
                object.data = image.data
                self.dataController.save()
                return UIImage(data: image.data)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                guard let imageToCache = $0 else {
                    self.image = UIImage(named: "placeholder")
                    return
                }
                self.image = imageToCache
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
