import SwiftUI
import CoreData
import Combine

class ViewModel: ObservableObject {
    @Published var developers = [Developer]()
    @Published var isLoading = false
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    private let developersCoreData = NSFetchRequest<Developer>(entityName: Developer.entityName)
    
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
        guard let url = URL(string: "https://jsonblob.com/api/jsonBlob/2fc11296-2375-11eb-a22c-6b6a9b841ba4") else {
            return
        }
        
        networkManager
            .fetch(url, defaultValue: [Developer]())
            .collect()
            .sink { [unowned self] values in
                let allItems = values.joined()
                self.developers = allItems.sorted(by: { $0.id < $1.id})
                self.isLoading = false
            }
            .store(in: &requests)
        
    }
}
