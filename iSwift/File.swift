//import Foundation
//import CoreData
//
//class DecoderWrapper: Decodable {
//
//    let decoder: Decoder
//
//    required init(from decoder:Decoder) throws {
//
//        self.decoder = decoder
//    }
//}
//
//protocol JSONDecoding {
//     func decodeWith(_ decoder: Decoder) throws
//}
//
//extension JSONDecoding where Self: NSManagedObject {
//
//    func decode(json:[String:Any]) throws {
//
//        let data = try JSONSerialization.data(withJSONObject: json, options: [])
//        let wrapper = try JSONDecoder().decode(DecoderWrapper.self, from: data)
//        try decodeWith(wrapper.decoder)
//    }
//}
//
//extension Developer: JSONDecoding {
//
//    enum CodingKeys: String, CodingKey {
//        case articles, dev, id, background, profilePic // For example
//    }
//
//    func decodeWith(_ decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
////        self.articles = try container.decode(String.self, forKey: .articles)
//        id = try container.decode(String.self, forKey: .id)
//        dev = try container.decode(String.self, forKey: .dev)
//        background = try container.decode(String.self, forKey: .background)
//        profilePic = try container.decode(String.self, forKey: .profilePic)
//    }
//}
//
//extension Developer {
//    
//    static var example: Developer {
//        let controller = DataController(inMemory: true)
//        let viewContext = controller.container.viewContext
//        
//        let developer = Developer(context: viewContext)
//        developer.articles = []
//        developer.dev = "Anonymus"
//        developer.id = UUID().uuidString
//        developer.background = ""
//        developer.profilePic = ""
//        
//        return developer
//    }
//}
