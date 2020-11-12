import SwiftUI
import Combine


class ViewModel {
    var dataController: DataController
    private var requests = Set<AnyCancellable>()
    
    init() {
        dataController = DataController()
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
            .sink(receiveValue: completion)
            .store(in: &requests)
    }
}
