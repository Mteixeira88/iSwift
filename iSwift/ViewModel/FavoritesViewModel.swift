import Foundation
import Combine
import CoreData

class FavoritesViewModel: ObservableObject {
    private var dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
        print("init")
    }
}
