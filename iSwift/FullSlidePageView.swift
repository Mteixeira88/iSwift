import SwiftUI

struct FullSlidePageView: View {
    var model: SlideItemViewModel
    
    var body: some View {
        NavigationLink(destination: Text(model.title)) {
            VStack(alignment: .leading) {
                Text(model.title)
                    .foregroundColor(.blue)
                AsyncImage(url: model.imageURL)
                    .cornerRadius(10)
            }
        }
        .buttonStyle(PlainButtonStyle())
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
