import SwiftUI

struct DetailsModel {
    let author: AuthorModel
    let items: [TopicDetailModel]
    
    static let `default` = DetailsModel(author: AuthorModel(name: "", description: "", image: ""), items: [])
}

struct TopicDetailModel: Identifiable {
    let id: String
    let title: String
    let description: String
}

struct AuthorModel {
    let name: String
    let description: String
    let image: String
}

struct DetailsView: View {
    @ObservedObject var viewModel: TopicViewModel
    @EnvironmentObject var dataController: DataController
    var id: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                if viewModel.topics.items.isEmpty {
                    EmptyView {
                        viewModel.getTopicsBy(id)
                    }
                } else {
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: viewModel.topics.author.image, dataController: dataController)
                                .frame(width: 60, height: 60)
                                .cornerRadius(60)
                            VStack(alignment: .leading) {
                                Text(viewModel.topics.author.name)
                                    .font(.title)
                                Text(viewModel.topics.author.description)
                                    .font(.caption2)
                            }
                            
                        }
                        .padding(.horizontal)
                        Divider()
                            .padding(.top)
                        List {
                            ForEach(viewModel.topics.items) { topic in
                                NavigationLink(
                                    destination: FinalItemsListView(
                                        viewModel: ArticlesViewModel(dataController: dataController),
                                        id: topic.id
                                    )
                                ) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(topic.title)
                                        Text(topic.description)
                                            .font(.caption)
                                            .foregroundColor(Color(UIColor.systemGray))
                                    }
                                    .padding(.bottom, 10)
                                }
                                
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationBarTitle("Topics", displayMode: .inline)
        .onAppear {
            if viewModel.topics.items.isEmpty {
                viewModel.getTopicsBy(id)
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(viewModel: TopicViewModel(dataController: DataController()), id: "")
    }
}
