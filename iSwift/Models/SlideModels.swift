import Foundation
import SwiftUI

struct SlidePageViewModel: Identifiable {
    let id: String
    let title: String
    let order: Int16
    var items: [UIHostingController<AnyView>]
}

struct SlideItemViewModel: Identifiable {
    let id: String
    let title: String
    let description: String
    let imageURL: String
}
