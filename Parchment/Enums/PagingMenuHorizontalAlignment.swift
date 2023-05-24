import Foundation

public enum PagingMenuHorizontalAlignment {
    case left

  // Allows all paging items to be centered within the paging menu
  // when PagingMenuItemSize is .fixed and the sum of the widths
  // of all the paging items are less than the paging menu
    case center
    // Allows all paging items to be right centered within the paging menu
    // when PagingMenuItemSize is .fixed and the sum of the widths
    // of all the paging items are less than the paging menu
    case right
    // The items are evenly distributed within the alignment container along the main axis.
    // The spacing between each pair of adjacent items is the same.
    // The first item is flush with the main-start edge, and the last item is flush with the main-end edge.
    // when PagingMenuItemSize is .fixed and the sum of the widths
    // of all the paging items are less than the paging menu
    case spaceBetween
    // The items are evenly distributed within the alignment container along the main axis.
    // The spacing between each pair of adjacent items is the same.
    // The empty space before the first and after the last item equals half of the space between each pair of adjacent items.
    // when PagingMenuItemSize is .fixed and the sum of the widths
    // of all the paging items are less than the paging menu
    case spaceAround
    // The items are evenly distributed within the alignment container along the main axis. 
    // The spacing between each pair of adjacent items, the main-start edge and the first item,
    // and the main-end edge and the last item, are all exactly the same.
    // when PagingMenuItemSize is .fixed and the sum of the widths
    // of all the paging items are less than the paging menu
    case spaceEvenly
}
