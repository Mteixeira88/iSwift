import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(viewModel: HomeViewModel(dataController: dataController))
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var viewModel = HomeViewModel(dataController: dataController)
    
    static var previews: some View {
        ContentView()
            .environmentObject(viewModel)
    }
}
