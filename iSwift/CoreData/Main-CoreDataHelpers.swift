import Foundation
import CoreData


class Main: NSManagedObject, Decodable {
    static let entityName = "Main"
    
    enum CodingKeys: String, CodingKey {
        case id, name, linkId, updatedAt, order
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        linkId = try container.decode(String.self, forKey: .linkId)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        order = Int16(try container.decode(Int.self, forKey: .order))
    }
}
