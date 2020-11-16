import SwiftUI

struct ListSlidePageView: View {
    var model: [SlideItemViewModel]
    
    var body: some View {
        List {
            ForEach(model) { item in
                Text(item.title)
            }
            .frame(height: 100)
        }
    }
}

struct ListSlidePageView_Previews: PreviewProvider {
    static var previews: some View {
        ListSlidePageView(model: [])
    }
}
