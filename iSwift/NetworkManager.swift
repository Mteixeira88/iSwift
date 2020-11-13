import Combine
import Foundation

class NetworkManager {
    private var dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
    }
    
    func fetch<T: Decodable>(_ url: URL, defaultValue: T) -> AnyPublisher<T, Never> {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = dataController.container.viewContext
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
