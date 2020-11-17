import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader

    
    init(url: String, dataController: DataController) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url, dataController: dataController))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } else {
                ProgressView()
            }
        }
    }
}
