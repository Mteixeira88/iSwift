import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        if viewModel.isLoading {
            ProgressView()
        } else {
            GeometryReader { geometry in
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.sliders) { slider in
                            VStack(alignment: .leading) {
                                Text(slider.title)
                                    PageViewController(controllers: slider.items)
                                        .frame(width: geometry.size.width - 32, height: 200)
                            }
                        }
                    }
                    .navigationTitle(Text("Home"))
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
