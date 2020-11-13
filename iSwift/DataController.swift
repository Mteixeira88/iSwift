import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Data")
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
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
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchDeveloperRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Developer.entityName)
        let batchDeleteRequestDeveloper = NSBatchDeleteRequest(fetchRequest: fetchDeveloperRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestDeveloper)
        
        let fetchSocialRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Social.entityName)
        let batchDeleteRequestSocial = NSBatchDeleteRequest(fetchRequest: fetchSocialRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestSocial)
        
        let fetchTopicRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Topic.entityName)
        let batchDeleteRequestTopic = NSBatchDeleteRequest(fetchRequest: fetchTopicRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestTopic)
    }
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let developer = Developer(context: viewContext)
            developer.id = UUID().uuidString
            developer.dev = "Dev \(i)"
            developer.background = ""
            developer.profilePic = ""
            developer.updatedAt = Date()
            developer.topics = []
            
            let social = Social(context: viewContext)
            social.github = "https://www.github.com"
            social.twitter = "https://www.twitter.com"
            
            developer.social = social
            
            for j in 1...4 {
                let topic = Topic(context: viewContext)
                topic.id = UUID().uuidString
                topic.developer = developer
                topic.name = "Topic \(j)"
            }
        }
        
        try viewContext.save()
    }
}

