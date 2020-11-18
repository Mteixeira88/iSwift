import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    
    private let mainCoreData = NSFetchRequest<Main>(entityName: Main.entityName)
    private let sectionCoreData = NSFetchRequest<Section>(entityName: Section.entityName)
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Data")
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
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
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteEntity(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
    
    func deleteAll() {
        let fetchMainRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Main.entityName)
        let batchDeleteRequestMain = NSBatchDeleteRequest(fetchRequest: fetchMainRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestMain)
        
        let fetchDeveloperRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Section.entityName)
        let batchDeleteRequestDeveloper = NSBatchDeleteRequest(fetchRequest: fetchDeveloperRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestDeveloper)
        
        let fetchSocialRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Social.entityName)
        let batchDeleteRequestSocial = NSBatchDeleteRequest(fetchRequest: fetchSocialRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestSocial)
        
        let fetchTopicRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Topic.entityName)
        let batchDeleteRequestTopic = NSBatchDeleteRequest(fetchRequest: fetchTopicRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestTopic)
        
        let fetchArticleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Article.entityName)
        let batchDeleteRequestArticle = NSBatchDeleteRequest(fetchRequest: fetchArticleRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestArticle)
        
        let fetchArticleContentRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ArticleContent.entityName)
        let batchDeleteRequestArticleContent = NSBatchDeleteRequest(fetchRequest: fetchArticleContentRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestArticleContent)
        
        let fetchArticleInfoRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ArticleInfo.entityName)
        let batchDeleteRequestArticleInfo = NSBatchDeleteRequest(fetchRequest: fetchArticleInfoRequest)
        _ = try? container.viewContext.execute(batchDeleteRequestArticleInfo)
    }
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let section = Section(context: viewContext)
            section.id = UUID().uuidString
            section.name = "Dev \(i)"
            section.background = ""
            section.profilePic = ""
            section.updatedAt = Date()
            section.topics = []
            
            let social = Social(context: viewContext)
            social.github = "https://www.github.com"
            social.twitter = "https://www.twitter.com"
            
            section.social = social
            
            for j in 1...4 {
                let topic = Topic(context: viewContext)
                topic.id = UUID().uuidString
                topic.section = section
                topic.name = "Topic \(j)"
            }
        }
        
        try viewContext.save()
    }
}

