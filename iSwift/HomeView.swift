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
            NavigationView {
                List {
                    ForEach(viewModel.developers) { dev in
                        VStack(alignment: .leading) {
                            Text(dev.name ?? "No dev")
                            NavigationLink(destination: Text(dev.name ?? "No dev")) {
                                Text(dev.linkId ?? "No dev")
                            }
                        }
                    }
                }
                .navigationTitle(Text("Home"))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
