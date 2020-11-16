import Foundation
import CoreData


class Section: NSManagedObject, Decodable {
    static let entityName = "Section"
    
    static var example: [Section] {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let developer = Section(context: viewContext)
        developer.dev = "Anonymus"
        developer.id = UUID().uuidString
        developer.background = ""
        developer.profilePic = ""
        
        return [developer]
    }
    
    enum CodingKeys: String, CodingKey {
        case dev, id, background, profilePic, updatedAt, social, topicId
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        topicId = try container.decode(String.self, forKey: .topicId)
        dev = try container.decode(String.self, forKey: .dev)
        background = try container.decode(String.self, forKey: .background)
        profilePic = try container.decode(String.self, forKey: .profilePic)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        social = try container.decode(Social.self, forKey: .social)
    }
}
