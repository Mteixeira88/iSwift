import Combine
import Foundation

class NetworkManager {
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func fetch<T: Decodable>(_ url: URL, defaultValue: T,completion: @escaping (T) -> Void) {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = dataController.container.viewContext
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: completion)
            .store(in: &requests)
    }
}
