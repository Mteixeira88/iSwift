import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(viewModel: HomeViewModel(dataController: dataController))
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: selectedView == HomeView.tag || selectedView == nil ? "house.fill" : "house")
                }
            FavoritesView()
                .tag(FavoritesView.tag)
                .tabItem {
                    Image(systemName: selectedView == "Favorites" ? "star.fill" : "star")
                }
            Text("Settings")
                .tag("Settings")
                .tabItem {
                    Image(systemName: selectedView == "Settings" ? "person.fill" : "person")
                }
        }
        .accentColor(Color.orange)
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
