import SwiftUI

struct FullSlidePageView: View {
    var model: SlideItemViewModel
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        GeometryReader { geo in
            NavigationLink(
                destination: DetailsView(
                    viewModel:
                        TopicViewModel(
                            dataController: dataController
                        ),
                        id: model.id
                )
            ) {
                VStack(alignment: .leading) {
                    Text(model.title)
                        .foregroundColor(.blue)
                    AsyncImage(url: model.imageURL)
                        .frame(width: geo.size.width, height: 150)
                        .cornerRadius(10)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct SlidePageView_Previews: PreviewProvider {
    static var previews: some View {
        FullSlidePageView(model:
                            SlideItemViewModel(
                                id: "",
                                title: "title",
                                description: "description",
                                imageURL: ""
                            )
        )
    }
}
