import SwiftUI

class ViewModel: ObservableObject {
    @Published var developers = [Developer]()
    @Published var articles = [Article]()
    private var networkManager: NetworkManager
    
    init(dataController: DataController) {
        networkManager = NetworkManager(dataController: dataController)
        getDevelopers()
    }
    
    func getDevelopers() {
        let url = URL(string: "https://jsonblob.com/api/jsonBlob/2fc11296-2375-11eb-a22c-6b6a9b841ba4")!
        networkManager.fetch(url, defaultValue: Developer.example) { [unowned self] (devs) in
            self.developers = devs
        }
    }
}
