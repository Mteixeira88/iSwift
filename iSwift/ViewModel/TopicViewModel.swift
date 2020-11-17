import Combine
import CoreData

class TopicViewModel: ObservableObject {
    @Published var topics = DetailsModel.default
    @Published var isLoading = false
    
    private let sectionCoreData = NSFetchRequest<Section>(entityName: Section.entityName)
    private let topicCoreData = NSFetchRequest<Topic>(entityName: Topic.entityName)
    private var topicsData = [Topic]()
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
            topicsData = topicsCoreData.filter({ $0.section == section })
            if !topicsData.isEmpty {
                buildDetailsModel(with: topicsData, section: section)
            }
        }
        print("saved", topicsData)
        
        networkManager.fetch(url, defaultValue: [Topic]())
            .collect()
            .sink { [weak self] topicsValues in
                guard let self = self else { return }
                let topics = topicsValues.joined().map({ $0 })
                if !topics.isEmpty,
                   self.needsCacheUpdate(for: topics) {
                    self.buildDetailsModel(with: topics, section: section)
                    self.updateCache(with: topics, section: section)
                }
            }
            .store(in: &requests)
    }
    
    private func needsCacheUpdate(for topics: [Topic]) -> Bool {
        let topicsCompare = topics
        topicsCompare.forEach { (topic) in
            topic.section = nil
        }
        if !topics.elementsEqual(topicsCompare, by: { $0.updatedAt == $1.updatedAt }) {
            dataController.deleteEntity(Topic.entityName)
            self.topics = DetailsModel.default
            isLoading = true
            return true
        }
        return false
    }
    
    private func buildDetailsModel(with topics: [Topic], section: Section) {
        print(topics)
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
        isLoading = false
    }
    
    private func updateCache(with topics: [Topic], section: Section) {
        print("caching")
        let viewContext = dataController.container.viewContext
        
        topics.forEach { (topic) in
            let topicData = Topic(context: viewContext)
            topicData.section = section
            topicData.id = topic.id
            topicData.name = topic.name
            topicData.detail = topic.detail
        }
        
        dataController.save()
    }
}
