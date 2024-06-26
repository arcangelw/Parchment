import Parchment
import UIKit

// This first thing we need to do is to create our own custom paging
// view and override the layout constraints. The default
// implementation positions the menu view above the page view
// controller, but since we want to overlay the menu above the page
// view and store the top constraint so that we can update it when
// the user is scrolling.
class ScrollPagingView: PagingView {
    var menuTopConstraint: NSLayoutConstraint?

    override func setupConstraints() {
        pageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        menuTopConstraint = collectionView.topAnchor.constraint(equalTo: topAnchor)
        menuTopConstraint?.isActive = true

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight),

            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}

// Create a custom paging view controller and override the view with
// our own custom subclass.
class ScrollPagingViewController: PagingViewController {
    override func loadView() {
        view = ScrollPagingView(
            options: options,
            collectionView: collectionView,
            pageView: pageViewController.view
        )
    }
}

class ScrollViewController: UIViewController {
    private let pagingViewController = ScrollPagingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the paging view controller as a child view controller and
        // constrain it to all edges.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)

        // Prevent the menu from showing when scrolled out of view.
        pagingViewController.view.clipsToBounds = true

        // Set our data source and delegate.
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
    }

    /// Calculate the menu offset based on the content offset of the scroll view.
    private func menuOffset(for scrollView: UIScrollView) -> CGFloat {
        return min(pagingViewController.options.menuHeight, max(0, scrollView.contentOffset.y))
    }
}

extension ScrollViewController: PagingViewControllerDataSource {
    func pagingViewController(_: PagingViewController, viewControllerAt _: Int) -> UIViewController {
        let viewController = TableViewController()

        // Inset the table view with the height of the menu height.
        let menuHeight = pagingViewController.options.menuHeight
        let insets = UIEdgeInsets(top: menuHeight, left: 0, bottom: 0, right: 0)
        viewController.tableView.contentInset = insets
        viewController.tableView.scrollIndicatorInsets = insets

        // Set delegate so that we can listen to scroll events.
        viewController.tableView.delegate = self

        // Ensure that the scroll view is scroll to the top.
        viewController.tableView.contentOffset.y = -insets.top

        return viewController
    }

    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: "View \(index)")
    }

    func numberOfViewControllers(in _: PagingViewController) -> Int {
        return 3
    }
}

extension ScrollViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Only update the menu when the currently selected view is scrolled.
        guard
            let selectedViewController = pagingViewController.pageViewController.selectedViewController as? TableViewController,
            selectedViewController.tableView === scrollView
        else { return }

        // Offset the menu view based on the content offset of the scroll view.
        if let menuView = pagingViewController.view as? ScrollPagingView {
            menuView.menuTopConstraint?.constant = -menuOffset(for: scrollView)
        }
    }
}

extension ScrollViewController: PagingViewControllerDelegate {
    // We want to transition the menu offset smoothly to it correct
    // position when we are swiping between pages.
    func pagingViewController(_: PagingViewController, isScrollingFromItem _: PagingItem, toItem _: PagingItem?, startingViewController: UIViewController, destinationViewController: UIViewController?, progress: CGFloat) {
        guard let destinationViewController = destinationViewController as? TableViewController else { return }
        guard let startingViewController = startingViewController as? TableViewController else { return }
        guard let menuView = pagingViewController.view as? ScrollPagingView else { return }

        // Tween between the current menu offset and the menu offset of
        // the destination view controller.
        let from = menuOffset(for: startingViewController.tableView)
        let to = menuOffset(for: destinationViewController.tableView)
        let offset = ((to - from) * abs(progress)) + from

        // Reset the content offset when scrolling to a new page. You
        // could also remove this, and it will hide the menu when
        // swiping back to the previous page.
        destinationViewController.tableView.contentOffset.y = -pagingViewController.options.menuHeight

        menuView.menuTopConstraint?.constant = -offset
    }
}
