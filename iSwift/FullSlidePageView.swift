import SwiftUI

struct FullSlidePageView: View {
    var model: SlideItemViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack {
                Spacer()
                Text(model.title)
                Spacer()
            }
            Spacer()
        }
        .background(Color.red)
    }
}

struct SlidePageView_Previews: PreviewProvider {
    static var previews: some View {
        FullSlidePageView(model:
                        SlideItemViewModel(
                            id: "",
                            title: "title",
                            description: "description",
                            image: Image(systemName: "person")
                        )
        )
    }
}
