
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
        PageViewController(flaggedProjectCards: flaggedProjectCards)
    }
}

struct PageViewController: UIViewControllerRepresentable {
    let flaggedProjectCards: [FlaggedProjectCard]
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        let flaggedProjectCardHostingController = UIHostingController(rootView: flaggedProjectCards[0])
        
        uiViewController.setViewControllers([flaggedProjectCardHostingController], direction: .forward, animated: true, completion: nil)
    }
    
    typealias UIViewControllerType = UIPageViewController
}

struct FlaggedProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectsPageView(flaggedProjects: RenovationProject.testData)
    }
}
