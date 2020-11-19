import Foundation
import Combine
import CoreData

class ArticlesViewModel: ObservableObject {
    @Published var articles = [FinalItemModelView]()
    @Published var isLoading = false
    
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    private let topicCoreData = NSFetchRequest<Topic>(entityName: Topic.entityName)
    
    init(dataController: DataController) {
        self.dataController = dataController
        networkManager = NetworkManager(dataController: dataController)
    }
    
    func getArticles(from id: String) {
        self.articles = []
        isLoading = true
        let viewContext = dataController.container.viewContext
        topicCoreData.predicate = NSPredicate(format: "id = %@", id)
        
        guard let result = try? viewContext.fetch(topicCoreData),
              !result.isEmpty,
              let topicId = result[0].articlesId,
              let url = URL(string: "https://jsonblob.com/api/jsonBlob/\(topicId)") else {
            return
        }
        
        networkManager.fetch(url, defaultValue: [Article]())
            .collect()
            .sink { [weak self] articlesValue in
                guard let self = self else { return }
                let articles = articlesValue.joined().map({ $0 })
                self.buildArticlesModel(with: articles)
                
//                if topics.isEmpty {
//                    self.isLoading = false
//                } else {
//                    if self.needsCacheUpdate(for: topics) {
//                        print("using server topics")
//                        self.buildDetailsModel(with: topics, section: section)
//                        self.updateCache(with: topics, section: section)
//                    }
//                }
            }
            .store(in: &requests)
    }
    
    private func buildArticlesModel(with articles: [Article]) {
        self.articles = articles.map { article -> FinalItemModelView in
            guard let content = article.content?.allObjects as? [ArticleContent] else {
                return FinalItemModelView(id: "", sectionName: "", sectionDetail: "", content: [])
            }
            
            return FinalItemModelView(
                id: article.id ?? "",
                sectionName: article.additionalInfo?.title ?? "",
                sectionDetail: article.additionalInfo?.detail ?? "",
                content: content.sorted(by: { $0.id ?? "" > $1.id ?? "Date" }).map({ (content) -> ArticleModelView in
                    ArticleModelView(
                        id: content.id ?? "",
                        title: content.title ?? "",
                        detail: content.detail ?? "",
                        url: URL(string: content.link ?? "")!
                    )
                })
            )
        }
        isLoading = false
    }
}
