import Foundation
import CoreData


class Developer: NSManagedObject, Decodable {
    static let entityName = "Developer"
    
    static var example: [Developer] {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let developer = Developer(context: viewContext)
        developer.dev = "Anonymus"
        developer.id = UUID().uuidString
        developer.background = ""
        developer.profilePic = ""
        
        return [developer]
    }
    
    enum CodingKeys: String, CodingKey {
        case dev, id, background, profilePic, updatedAt, social
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        dev = try container.decode(String.self, forKey: .dev)
        background = try container.decode(String.self, forKey: .background)
        profilePic = try container.decode(String.self, forKey: .profilePic)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        social = try container.decode(Social.self, forKey: .social)
    }
}
