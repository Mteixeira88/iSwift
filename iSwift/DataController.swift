import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MainContainer")
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory {
            container
                .persistentStoreDescriptions
                .first?
                .url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            
        }
    }
    
    static var preview: DataController = {
       let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fata error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
    }
}

