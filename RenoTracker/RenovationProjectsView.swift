
import SwiftUI

struct RenovationProjectsView: View {
    @Binding var renovationProjects: [RenovationProject]
    var flaggedProjects: [RenovationProject] {
        renovationProjects.filter { renovationProject in
            renovationProject.isFlagged == true
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if flaggedProjects.count > 0 {
                    FlaggedProjectsPageView(flaggedProjects: flaggedProjects)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
                ForEach(renovationProjects) { renovationProject in
                    let projectIndex = renovationProjects.firstIndex(where: { $0.id == renovationProject.id })!
                    
                    let renovationProjectBinding = $renovationProjects[projectIndex]
                    
                    NavigationLink(destination: DetailView(renovationProject: renovationProjectBinding)) {
                        RenovationProjectRow(renovationProject: renovationProject)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    struct StatefulPreviewWrapper: View {
        @State private var testProjects = RenovationProject.testData
        
        var body: some View {
            RenovationProjectsView(renovationProjects: $testProjects)
        }
    }
    
    static var previews: some View {
        StatefulPreviewWrapper()
    }
}
