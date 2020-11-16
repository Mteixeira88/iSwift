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
                        Divider()
                        VStack(alignment: .leading) {
                            ForEach(viewModel.sliders) { slider in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(slider.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Spacer()
                                        NavigationLink(destination: Text(slider.title)) {
                                            Text("See all")
                                        }
                                    }
                                    if !slider.items.isEmpty {
                                        PageViewController(controllers: slider.items)
                                            .frame(width: geometry.size.width - 32, height: 200)
                                    }
                                }
                                .padding()
                                Divider()
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
