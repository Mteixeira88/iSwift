import SwiftUI
import CoreData
import Combine

struct PresentationView {
    let id: String
    let title: String
    let items: [PresentationItemView]
    
    struct PresentationItemView {
        let id: String
        let title: String
        let description: String
        let image: String
    }
}

class ViewModel: ObservableObject {
    @Published var developers = [Main]()
    @Published var isLoading = false
    
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    private let developersCoreData = NSFetchRequest<Main>(entityName: Main.entityName)
    
    init(dataController: DataController) {
        self.dataController = dataController
        networkManager = NetworkManager(dataController: dataController)
        getContent()
    }
    
    private func getContent() {
        isLoading = true
        let viewContext = dataController.container.viewContext
        guard let result = try? viewContext.fetch(developersCoreData) else {
            return
        }
        
//        dataController.deleteAll()
        
        if !result.isEmpty {
            isLoading = false
            developers = result
        }

        getDevelopers()
    }
    
    private func getDevelopers() {
        guard let url = URL(string: "https://iswift-d731e.firebaseio.com/.json") else {
            return
        }
        
        networkManager
            .fetch(url, defaultValue: [Main]())
            .flatMap { details in
                details
                    .publisher
                    .flatMap { dev -> AnyPublisher<[Developer], Never> in
                        let detailURL = URL(string: "https://jsonblob.com/api/jsonBlob/\(dev.linkId!)")!
                    self.developers.append(dev)
                    return self.networkManager.fetch(detailURL, defaultValue: [Developer]())
                }
            }
            .collect()
            .sink { [unowned self] values in
                let allItems = values.joined()
                print(allItems)
//                self.developers = allItems.sorted(by: { $0.order < $1.order})
                self.isLoading = false
            }
            .store(in: &requests)
        
    }
}
