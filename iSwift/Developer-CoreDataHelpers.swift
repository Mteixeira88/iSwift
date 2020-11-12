import Foundation
import CoreData
extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

extension Developer {
    
    static var example: [Developer] {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let developer = Developer(context: viewContext)
        developer.articles = []
        developer.dev = "Anonymus"
        developer.id = UUID().uuidString
        developer.background = ""
        developer.profilePic = ""
        
        return [developer]
    }
}
