import Foundation
import UIKit

class PagingSizeCache {
    var options: PagingOptions
    var implementsSizeDelegate: Bool = false
    var sizeForPagingItem: ((PagingItem, Bool) -> CGFloat?)?

    private var sizeCache: [Int: CGFloat] = [:]
    private var selectedSizeCache: [Int: CGFloat] = [:]

    init(options: PagingOptions) {
        self.options = options

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveMemoryWarning(notification:)),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func clear() {
        sizeCache = [:]
        selectedSizeCache = [:]
    }

    func itemSize(for pagingItem: PagingItem) -> CGFloat {
        if let size = sizeCache[pagingItem.identifier] {
            return size
        } else {
            let size = sizeForPagingItem?(pagingItem, false)
            sizeCache[pagingItem.identifier] = size
            return size ?? options.estimatedItemWidth
        }
    }

    func itemWidthSelected(for pagingItem: PagingItem) -> CGFloat {
        if let size = selectedSizeCache[pagingItem.identifier] {
            return size
        } else {
            let size = sizeForPagingItem?(pagingItem, true)
            selectedSizeCache[pagingItem.identifier] = size
            return size ?? options.estimatedItemWidth
        }
    }

    @objc private func didReceiveMemoryWarning(notification _: NSNotification) {
        clear()
    }
}
