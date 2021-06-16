
import SwiftUI

struct RenovationProjectsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: DetailView(),
                    label: {
                        RenovationProjectRow()
                    })
                RenovationProjectRow()
                RenovationProjectRow()
            }
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RenovationProjectsView()
    }
}
