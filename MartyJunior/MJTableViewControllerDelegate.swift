//
//  MJTableViewControllerDelegate.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//


import UIKit

protocol MJTableViewControllerScrollDelegate: class {
    func tableViewController(viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell)
    func tableViewController(viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewDidZoom scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewWillBeginDragging scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func tableViewController(viewController: MJTableViewController,  scrollViewWillBeginDecelerating scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndScrollingAnimation scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView?
    func tableViewController(viewController: MJTableViewController, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    func tableViewController(viewController: MJTableViewController, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool?
    func tableViewController(viewController: MJTableViewController, scrollViewDidScrollToTop scrollView: UIScrollView)
}

protocol MJTableViewControllerDelegate: class, MJTableViewControllerScrollDelegate {
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForTopCellAtIndexPath indexPath: NSIndexPath) -> CGFloat
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForTopCellAtIndexPath indexPath: NSIndexPath) -> CGFloat
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat?

    func tableViewController(viewController: MJTableViewController, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, viewForFooterInSection section: Int) -> UIView?

    func tableViewController(viewController: MJTableViewController, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)

    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    @available(iOS 8.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath)
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int?
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?)
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool?
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> NSIndexPath?
}