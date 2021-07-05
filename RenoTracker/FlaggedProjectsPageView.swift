
import SwiftUI

struct FlaggedProjectsPageView: View {
    let flaggedProjects: [RenovationProject]
    
    // Map over the array of flagged renovation projects and return a FlaggedProjectCard instance for each element.
    var flaggedProjectCards: [FlaggedProjectCard] {
        flaggedProjects.map { flaggedProject in
            FlaggedProjectCard(renovationProject: flaggedProject)
        }
    }
    
    var body: some View {
        //TODO: Render a UIPageViewController to display the flaggedProjectCards in
        flaggedProjectCards.first
    }
}

struct FlaggedProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectsPageView(flaggedProjects: RenovationProject.testData)
    }
}
