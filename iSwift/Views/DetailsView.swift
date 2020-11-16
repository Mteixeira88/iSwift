import SwiftUI

struct DetailsView: View {
    var id: String
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.topics) { topic in
                Text(topic.name ?? "no topic")
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.getTopicsBy(sectionId: id)
            }
            
            print(id)
        }
       
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(id: "")
    }
}
