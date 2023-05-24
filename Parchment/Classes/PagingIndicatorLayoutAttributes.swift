import UIKit

open class PagingIndicatorLayoutAttributes: UICollectionViewLayoutAttributes {
    #if compiler(>=6)
    nonisolated(unsafe) open var backgroundColor: UIColor?
    #else
    open var backgroundColor: UIColor?
    #endif

    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PagingIndicatorLayoutAttributes
        copy.backgroundColor = backgroundColor
        return copy
    }

    open override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? PagingIndicatorLayoutAttributes {
            if backgroundColor != rhs.backgroundColor {
                return false
            }
            return super.isEqual(object)
        } else {
            return false
        }
    }

    func configure(_ options: PagingOptions) {
        if case let .visible(height, index, _, insets) = options.indicatorOptions {
            backgroundColor = options.indicatorColor
            frame.size.height = height

            switch options.menuPosition {
            case .top:
                frame.origin.y = options.menuHeight - height - insets.bottom + insets.top
            case .bottom:
                frame.origin.y = insets.bottom
            }
            zIndex = index
        }
    }

    func update(from: PagingIndicatorMetric, to: PagingIndicatorMetric, progress: CGFloat) {
        frame.origin.x = tween(from: from.x, to: to.x, progress: progress)
        frame.size.width = tween(from: from.width, to: to.width, progress: progress)
    }

    func update(to metric: PagingIndicatorMetric) {
        frame.origin.x = metric.x
        frame.size.width = metric.width
    }
}
