import SwiftUI

struct ContentView: View {
    @State private var selectedView = HomeView.tag
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(viewModel: HomeViewModel(dataController: dataController))
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(HomeView.tag)
            FavoritesView(viewModel: FavoritesViewModel(dataController: dataController))
                .tabItem {
                    Image(systemName: "star")
                }
                .tag(FavoritesView.tag)
            SettingsView()
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(SettingsView.tag)
        }
        .accentColor(Color.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environmentObject(dataController)
    }
}
