
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
        ZStack(alignment: .bottomTrailing) {
            PageViewController(flaggedProjectCards: flaggedProjectCards)
            PageControl(numberOfPages: flaggedProjectCards.count, currentPage: 0)
                // 10 points of width for the dot, and 8 points extra as a buffer
                .frame(width: (10 + 8) * CGFloat(flaggedProjectCards.count))
                .padding([.bottom, .trailing], 5)
        }
        .aspectRatio(3 / 2, contentMode: .fit)
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

struct PageControl: UIViewRepresentable {
    let numberOfPages: Int
    let currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    typealias UIViewType = UIPageControl
    
    
}

struct FlaggedProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectsPageView(flaggedProjects: RenovationProject.testData)
    }
}
