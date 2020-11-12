import SwiftUI

struct ContentView: View {
    private var viewModel = ViewModel()
    
    var body: some View {
        Button("Fetch developers") {
            let url = URL(string: "https://jsonblob.com/api/jsonBlob/2fc11296-2375-11eb-a22c-6b6a9b841ba4")!
            viewModel.fetch(url, defaultValue: Developer.example) { (devs) in
                DispatchQueue.main.async {
                    print(devs[0].social)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
