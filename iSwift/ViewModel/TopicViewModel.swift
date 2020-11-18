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
        sectionCoreData.predicate = NSPredicate(format: "id = %@", sectionId)
        
        guard let result = try? viewContext.fetch(sectionCoreData),
              let topicsDataFetch = try? viewContext.fetch(topicCoreData),
              let sections = result.first(where: { $0.main != nil }),
              let topicsCoreData = sections.topics?.allObjects as? [Topic],
              let section = result.first(where: { $0.id == sectionId }),
              let topicId = section.topicId,
              let url = URL(string: "https://jsonblob.com/api/jsonBlob/\(topicId)") else {
            return
        }
        
        if !topicsCoreData.isEmpty {
            topicsData = topicsCoreData
            
            topicsDataFetch.forEach { (topic) in
                if topic.section?.main == nil {
                    dataController.delete(topic)
                }
            }
            
            DispatchQueue.main.async {
                self.buildDetailsModel(with: self.topicsData, section: section)
            }
        }
        
        networkManager.fetch(url, defaultValue: [Topic]())
            .collect()
            .sink { [weak self] topicsValues in
                guard let self = self else { return }
                let topics = topicsValues.joined().map({ $0 })
                if topics.isEmpty {
                    self.isLoading = false
                } else {
                    if self.needsCacheUpdate(for: topics) {
                        print("using server topics")
                        self.buildDetailsModel(with: topics, section: section)
                        self.updateCache(with: topics, section: section)
                    }
                }
            }
            .store(in: &requests)
    }
    
    private func needsCacheUpdate(for topics: [Topic]) -> Bool {
        let topicsCompare = topicsData.map({ topic in
            topic.updatedAt
        })
        let topicsServer = topics.map { topic in
            topic.updatedAt
        }
        print(topicsServer)
        print(topicsCompare)
        if !topicsServer.sorted(by: { $0!.compare($1!) == .orderedDescending })
            .elementsEqual(
                topicsCompare.sorted(by: { $0!.compare($1!) == .orderedDescending }), by: { $0 == $1 }
            ) {
            
            self.topics = DetailsModel.default
            isLoading = true
            return true
        }
        return false
    }
    
    private func buildDetailsModel(with topics: [Topic], section: Section) {
        let items = topics.map { topic in
            TopicDetailModel(id: topic.id ?? "", title: topic.name ?? "", description: topic.detail ?? "")
        }
        
        self.topics = DetailsModel(
            author: AuthorModel(
                name: section.name ?? "Failed",
                description: section.detail ?? "Something went wrong, check your internet please.",
                image: section.profilePic ?? ""
            ),
            items: items
        )
        isLoading = false
    }
    
    private func updateCache(with topics: [Topic], section: Section) {
        let viewContext = dataController.container.viewContext
        
        guard let result = try? viewContext.fetch(sectionCoreData),
              let topicsDataFetch = try? viewContext.fetch(topicCoreData),
              let sectionData = result.first(where: { $0.main != nil }) else {
            return
        }
        
        topicsDataFetch.forEach { (topic) in
            if topic.section?.id == section.id {
                dataController.delete(topic)
            }
        }
        
        topics.forEach { (topic) in
            let topicData = Topic(context: viewContext)
            topicData.section = sectionData
            topicData.id = topic.id
            topicData.name = topic.name
            topicData.detail = topic.detail
            topicData.updatedAt = topic.updatedAt
            topicData.articlesId = topic.articlesId
        }
        
        dataController.save()
        
        print("caching topics")
    }
}
