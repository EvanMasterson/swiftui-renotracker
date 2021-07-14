
import SwiftUI

struct FlaggedProjectsPageView: View {
    let flaggedProjects: [RenovationProject]
    @State private var currentPage = 0
    
    // Map over the array of flagged renovation projects and return a FlaggedProjectCard instance for each element.
    var flaggedProjectCards: [FlaggedProjectCard] {
        flaggedProjects.map { flaggedProject in
            FlaggedProjectCard(renovationProject: flaggedProject)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(flaggedProjectCards: flaggedProjectCards, currentPage: $currentPage)
            PageControl(numberOfPages: flaggedProjectCards.count, currentPage: $currentPage)
                // 10 points of width for the dot, and 8 points extra as a buffer
                .frame(width: (10 + 8) * CGFloat(flaggedProjectCards.count))
                .padding([.bottom, .trailing], 5)
        }
        .aspectRatio(3 / 2, contentMode: .fit)
    }
}

struct PageViewController: UIViewControllerRepresentable {
    let flaggedProjectCards: [FlaggedProjectCard]
    @Binding var currentPage: Int
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        let flaggedProjectCardHostingController = UIHostingController(rootView: flaggedProjectCards[currentPage])
        
        uiViewController.setViewControllers([flaggedProjectCardHostingController], direction: .forward, animated: true, completion: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representableToCoordinate: self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        let representableToCoordinate: PageViewController

        internal init(representableToCoordinate: PageViewController) {
            self.representableToCoordinate = representableToCoordinate
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            <#code#>
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            <#code#>
        }
        

    }
    
    typealias UIViewControllerType = UIPageViewController
}

struct PageControl: UIViewRepresentable {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
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
