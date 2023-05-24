import UIKit

/// A custom `UICollectionViewCell` subclass used to display the menu
/// items. When creating your own custom cells, you need to subclass
/// this type instead of `UICollectionViewCell` directly.
open class PagingCell: UICollectionViewCell {

    /// The `UICollectionView` that this cell belongs to.
    public weak var collectionView: UICollectionView?

    /// Called by the `PagingViewControllerDataSource` to customize the
    /// cell with an instance conforming to `PagingItem`. You have to
    /// override this method when creating your own subclass – the
    /// default implementation will crash.
    ///
    /// - Parameter pagingItem: The `PagingItem` that is provided by the
    /// data source.
    /// - Parameter selected: A boolean to indicate whether the cell is
    /// currently selected.
    /// - Parameter options: The `PagingOptions` used to customize the
    /// look and feel of the `PagingViewController.
    open func setPagingItem(_: PagingItem, selected _: Bool, options _: PagingOptions) {
        fatalError("setPagingItem: not implemented")
    }

    /// Invalidates the item size of the cell.
    open func invalidateItemSize() {
        guard let collectionView else { return }
        // Create a PagingInvalidationContext to specify the invalidation type.
        let context = PagingInvalidationContext()
        context.invalidateSizes = true
        // Invalidate the layout of the collectionView using the created context.
        collectionView.collectionViewLayout.invalidateLayout(with: context)
    }
}
