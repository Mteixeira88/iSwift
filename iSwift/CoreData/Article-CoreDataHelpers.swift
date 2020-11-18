import Foundation
import CoreData


class Article: NSManagedObject, Decodable {
    static let entityName = "Article"
    
    enum CodingKeys: String, CodingKey {
        case id, additionalInfo, content
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        additionalInfo = try container.decode(ArticleInfo.self, forKey: .additionalInfo)
        content = NSSet(array: try container.decode([ArticleContent].self, forKey: .content))
    }
}

class ArticleInfo: NSManagedObject, Decodable {
    static let entityName = "ArticleInfo"
    
    enum CodingKeys: String, CodingKey {
        case title, description
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        detail = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
}

class ArticleContent: NSManagedObject, Decodable {
    static let entityName = "ArticleContent"
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, link
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        detail = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        link = try container.decode(String.self, forKey: .link)
    }
}
