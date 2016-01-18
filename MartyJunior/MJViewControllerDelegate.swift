//
//  MJViewControllerDelegate.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

@objc public protocol MJViewControllerScrollDelegate: class {
    optional func mjViewController(viewController: MJViewController, didChangeSelectedIndex selectedIndex: Int)
    optional func mjViewController(viewController: MJViewController, contentScrollViewDidScroll scrollView: UIScrollView)
    optional func mjViewController(viewController: MJViewController, contentScrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    optional func mjViewController(viewController: MJViewController, contentScrollViewDidEndDecelerating scrollView: UIScrollView)
    optional func mjViewController(viewController: MJViewController, contentScrollViewWillBeginDragging scrollView: UIScrollView)
    
    
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidScroll scrollView: UIScrollView)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidZoom scrollView: UIScrollView)
    
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginDragging scrollView: UIScrollView)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginDecelerating scrollView: UIScrollView)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidEndDecelerating scrollView: UIScrollView)
    
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidEndScrollingAnimation scrollView: UIScrollView)
    
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView?
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidScrollToTop scrollView: UIScrollView)
}

@objc public protocol MJViewControllerDelegate: class, MJViewControllerScrollDelegate {
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
    
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath)
    
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    @available(iOS 8.0, *)
    optional func mjViewController(viewController: MJViewController, selectedIndex: Int, tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath)
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?)
    
    @available(iOS 9.0, *)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool
    @available(iOS 9.0, *)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool
    @available(iOS 9.0, *)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    @available(iOS 9.0, *)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> NSIndexPath?
}