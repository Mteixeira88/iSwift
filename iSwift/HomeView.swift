import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        if viewModel.isLoading {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.developers) { dev in
                    Text(dev.dev ?? "No dev")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
