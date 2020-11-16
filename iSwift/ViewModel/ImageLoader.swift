import Foundation
import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    static let imageCache = NSCache<NSString, UIImage>()
    private var cancellable: AnyCancellable?
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func load() {
        if let imageFromCache = ImageLoader.imageCache.object(forKey: NSString(string: url)) {
            self.image = imageFromCache
            return
        }
        guard let url = URL(string: url) else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self,
                      let image = $0 else{
                    return
                }
                self.image = image
                ImageLoader.imageCache.setObject(image, forKey: NSString(string: self.url))
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
