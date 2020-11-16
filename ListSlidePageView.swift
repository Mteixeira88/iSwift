import SwiftUI

struct ListSlidePageView: View {
    var model: [SlideItemViewModel]
    
    var body: some View {
        ForEach(model) { item in
            Text(item.title)
                .frame(height: 80)
            Divider()
        }
    }
}

struct ListSlidePageView_Previews: PreviewProvider {
    static var previews: some    View {
        ListSlidePageView(model: [])
    }
}
