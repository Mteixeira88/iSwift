import SwiftUI

struct EmptyView: View {
    var callback: () -> Void
    var body: some View {
        Text("Unfortunally this is the first time you visit this topic and it's not cached. Check your internet connection and try again.")
            .font(.footnote)
            .foregroundColor(Color(UIColor.systemGray))
            .multilineTextAlignment(.center)
            .padding()
        Button {
            callback()
        } label: {
            Label("Try again", systemImage: "arrow.clockwise.circle.fill")
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView {
            print("pushed")
        }
    }
}
