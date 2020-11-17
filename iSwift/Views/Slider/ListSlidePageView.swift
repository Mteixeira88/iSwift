import SwiftUI

struct ListSlidePageView: View {
    var model: [SlideItemViewModel]
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ForEach(model.indices) { index in
            NavigationLink(
                destination: DetailsView(
                    viewModel:
                        TopicViewModel(dataController: dataController),
                        id: model[index].id
                )
            ) {
                VStack {
                    HStack {
                        AsyncImage(url: model[index].imageURL)
                            .frame(width: 30, height: 30)
                            .cornerRadius(30)
                        Text(model[index].title)
                            .frame(height: 70)
                        Spacer()
                    }
                    
                    if index.isMultiple(of: 2) {
                        Divider()
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ListSlidePageView_Previews: PreviewProvider {
    static var previews: some    View {
        ListSlidePageView(model: [])
    }
}
