
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
            PageViewController(flaggedProjectCards: flaggedProjectCards, currentPage: $currentPage).id(UUID())
            PageControl(numberOfPages: flaggedProjectCards.count, currentPage: $currentPage).id(UUID())
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
        let controller = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        let flaggedProjectCardHostingController = context.coordinator.hostingControllers[currentPage]
        
        uiViewController.setViewControllers([flaggedProjectCardHostingController], direction: .forward, animated: true, completion: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representableToCoordinate: self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let representableToCoordinate: PageViewController
        
        let hostingControllers: [UIHostingController<FlaggedProjectCard>]
        
        internal init(representableToCoordinate: PageViewController) {
            self.representableToCoordinate = representableToCoordinate
            
            // Map over the array of flagged project cards and return a FlaggedProjectCard wrapped in a UIHostingController for each element.
            self.hostingControllers = representableToCoordinate.flaggedProjectCards.map { flaggedProjectCard in
                UIHostingController(rootView: flaggedProjectCard)
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            // Look up the reference of the viewController (the UIHostingController wrapping the FlaggedProjectCard that's currently displayed in the UIPageViewController) inside the array of all hostingControllers that the UIPageViewController could be aware of.
            guard let index = (hostingControllers as [UIViewController]).firstIndex(of: viewController) else { return nil}
            
            // If this is the first card in the array of hostingControllers and the person were to swipe to go "before"... use the last card in the array of hosting controllers as the "viewControllerBefore"
            if index == 0 {
                return hostingControllers.last
            }
            
            // Otherwise, use the card at the index immediately prior to the one currently being shown as the "viewControllerBefore"
            return hostingControllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            // Look up the reference of the viewController (the UIHostingController wrapping the FlaggedProjectCard that's currently displayed in the UIPageViewController) inside the array of all hostingControllers that the UIPageViewController could be aware of.
            guard let index = (hostingControllers as [UIViewController]).firstIndex(of: viewController) else { return nil}
            
            // If this is the last card in the array of hostingControllers and the person were to swipe to go "after"... use the first card in the array of hosting controllers as the "viewControllerAfter"
            if index + 1 == hostingControllers.count {
                return hostingControllers.first
            }
            
            // Otherwise, use the card at the index immediately after the one currently being shown as the "viewControllerAfter"
            return hostingControllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = (hostingControllers as [UIViewController]).firstIndex(of: visibleViewController) {
                
                representableToCoordinate.currentPage = index
            }
        }
        
        typealias UIViewControllerType = UIPageViewController
    }
}

struct PageControl: UIViewRepresentable {
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representableToCoordinate: self)
    }
    
    typealias UIViewType = UIPageControl
    
    class Coordinator {
        let representableToCoordinate: PageControl
        
        internal init(representableToCoordinate: PageControl) {
            self.representableToCoordinate = representableToCoordinate
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) {
            representableToCoordinate.currentPage = sender.currentPage
        }
    }
}

struct FlaggedProjectPageView_Previews: PreviewProvider {
    static var previews: some View {
        FlaggedProjectsPageView(flaggedProjects: RenovationProject.testData)
    }
}
