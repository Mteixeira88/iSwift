import Foundation
import CoreData

class Topic: NSManagedObject, Decodable {
    static let entityName = "Topic"
    
    enum CodingKeys: String, CodingKey {
        case id, name, detail, updatedAt, articlesId
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        name = try container.decode(String.self, forKey: .name)
        detail = try container.decode(String.self, forKey: .detail)
        articlesId = try container.decode(String.self, forKey: .articlesId)
    }
}
