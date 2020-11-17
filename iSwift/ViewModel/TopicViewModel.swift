import Combine
import CoreData

class TopicViewModel: ObservableObject {
    @Published var topics = DetailsModel.default
    @Published var isLoading = false
    
    private let sectionCoreData = NSFetchRequest<Section>(entityName: Section.entityName)
    private let topicCoreData = NSFetchRequest<Topic>(entityName: Topic.entityName)
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    
    init(dataController: DataController) {
        self.dataController = dataController
        networkManager = NetworkManager(dataController: dataController)
    }
    
    func getTopicsBy(_ sectionId: String) {
        self.topics = DetailsModel.default
        isLoading = true
        let viewContext = dataController.container.viewContext
        guard let result = try? viewContext.fetch(sectionCoreData),
              let topicsCoreData = try? viewContext.fetch(topicCoreData),
              let section = result.first(where: { $0.id == sectionId }),
              let topicId = section.topicId,
              let url = URL(string: "https://jsonblob.com/api/jsonBlob/\(topicId)") else {
            return
        }
        
        if !topicsCoreData.isEmpty {
            
        }
        
        networkManager.fetch(url, defaultValue: [Topic]())
            .collect()
            .sink { [weak self] topicsValues in
                let topics = topicsValues.joined().map({ $0 })
                self?.buildDetailsModel(with: topics, section: section)
                self?.isLoading = false
            }
            .store(in: &requests)
    }
    
    private func buildDetailsModel(with topics: [Topic], section: Section) {
        let items = topics.map { topic in
            TopicDetailModel(id: topic.id ?? "", title: topic.name ?? "", description: topic.detail ?? "")
        }
        self.topics = DetailsModel(
            author: AuthorModel(
                name: section.name ?? "Anonymus",
                description: section.detail ?? "No detail",
                image: section.profilePic ?? ""
            ),
            items: items
        )
    }
}
