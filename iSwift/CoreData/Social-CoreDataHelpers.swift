import Foundation
import CoreData

class Social: NSManagedObject, Decodable {
    static let entityName = "Social"
    
    enum CodingKeys: String, CodingKey {
        case github, twitter
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        github = try container.decode(String.self, forKey: .github)
        twitter = try container.decode(String.self, forKey: .twitter)
    }
}
