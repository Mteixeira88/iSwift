import SwiftUI

@main
struct iSwiftApp: App {
    @StateObject private var viewModel: ViewModel
    @StateObject private var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        
        let vm = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: vm)
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
