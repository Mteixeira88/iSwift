import SwiftUI

struct ListSlidePageView: View {
    var model: [SlideItemViewModel]
    
    var body: some View {
        ForEach(model.indices) { index in
            VStack {
                HStack {
                    AsyncImage(url: model[index].imageURL)
                        .frame(width: 30, height: 30)
                        .cornerRadius(30)
                    Text(model[index].title)
                        .frame(height: 70)
                    Spacer()
                }
                Spacer()
            }
            
            if index.isMultiple(of: 2) {
                Divider()
            }
        }
    }
}

struct ListSlidePageView_Previews: PreviewProvider {
    static var previews: some    View {
        ListSlidePageView(model: [])
    }
}
