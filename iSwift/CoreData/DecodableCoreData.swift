import CoreData


enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            fatalError(DecoderConfigurationError.missingManagedObjectContext.localizedDescription)
        }
        self.init(entity: entity, insertInto: context)
    }

}

