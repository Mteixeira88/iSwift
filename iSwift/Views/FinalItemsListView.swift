import SwiftUI
import SafariServices

struct FinalItemModelView: Identifiable {
    let id: String
    let sectionName: String
    let sectionDetail: String
    let content: [ArticleModelView]
}

struct ArticleModelView: Identifiable {
    let id: String
    let title: String
    let detail: String
    let url: URL
}

struct FinalItemsListView: View {
    @ObservedObject var viewModel: ArticlesViewModel
    var id: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if viewModel.articles.isEmpty {
                    EmptyView {
                        viewModel.getArticles(from: id)
                    }
                } else {
                    ScrollView {
                        ForEach(viewModel.articles) { article in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(article.sectionName)
                                        .font(.title3)
                                    Text(article.sectionDetail)
                                        .font(.caption)
                                        .foregroundColor(Color(UIColor.systemGray))
                                    Divider()
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            
                            ForEach(article.content) { content in
                                Link(destination: content.url) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(content.title)
                                            if content.detail != "" {
                                                Text(content.detail)
                                                    .font(.caption)
                                                    .foregroundColor(Color(UIColor.systemGray))
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                            }
                            Divider()
                                .padding(.vertical, 10)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Article", displayMode: .inline)
        .onAppear {
            viewModel.getArticles(from: id)
        }
    }
}

struct FinalItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        FinalItemsListView(viewModel: ArticlesViewModel(dataController: DataController()), id: "")
    }
}
