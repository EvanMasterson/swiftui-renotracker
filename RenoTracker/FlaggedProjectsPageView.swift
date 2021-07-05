
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
        PageViewController()
    }
}

struct PageViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIPageViewController {
        UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        // TODO: Implement updateUIViewController method
    }
    
    typealias UIViewControllerType = UIPageViewController
}

struct FlaggedProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectsPageView(flaggedProjects: RenovationProject.testData)
    }
}
