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
            if let image = loader.image {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
    }
}
