import CoreData


enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}

class Developer: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case dev, id, background, profilePic, social
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            print("error")
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        dev = try container.decode(String.self, forKey: .dev)
        background = try container.decode(String.self, forKey: .background)
        profilePic = try container.decode(String.self, forKey: .profilePic)
        social = try container.decode(Social.self, forKey: .social)
    }
}

class Article: NSManagedObject {
}
class ArticleContent: NSManagedObject {
}
class ArticleInfo: NSManagedObject {
}
class Social: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case github, twitter
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            print("error")
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        github = try container.decode(String.self, forKey: .github)
        twitter = try container.decode(String.self, forKey: .twitter)
    }
}

