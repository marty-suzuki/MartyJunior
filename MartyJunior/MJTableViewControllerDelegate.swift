//
//  MJTableViewControllerDelegate.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//


import UIKit

protocol MJTableViewControllerScrollDelegate: class {
    func tableViewController(_ viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidZoom scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillBeginDragging scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func tableViewController(_ viewController: MJTableViewController,  scrollViewWillBeginDecelerating scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndScrollingAnimation scrollView: UIScrollView)
    func tableViewController(_ viewController: MJTableViewController, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView?
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?)
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    func tableViewController(_ viewController: MJTableViewController, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidScrollToTop scrollView: UIScrollView)
}

protocol MJTableViewControllerDelegate: class, MJTableViewControllerScrollDelegate {
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForTopCellAtIndexPath indexPath: IndexPath) -> CGFloat
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForTopCellAtIndexPath indexPath: IndexPath) -> CGFloat
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat?

    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, viewForFooterInSection section: Int) -> UIView?

    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: IndexPath)

    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: IndexPath) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didHighlightRowAtIndexPath indexPath: IndexPath)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: IndexPath)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willSelectRowAtIndexPath indexPath: IndexPath) -> IndexPath?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDeselectRowAtIndexPath indexPath: IndexPath) -> IndexPath?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCellEditingStyle?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: IndexPath) -> String?
    @available(iOS 8.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: IndexPath) -> Bool?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: IndexPath)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: IndexPath)
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: IndexPath) -> Int?
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: IndexPath) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?)
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canFocusRowAtIndexPath indexPath: IndexPath) -> Bool?
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool?
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> IndexPath?
}
