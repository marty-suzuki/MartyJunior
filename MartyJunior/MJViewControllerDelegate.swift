//
//  MJViewControllerDelegate.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

@objc public protocol MJViewControllerScrollDelegate: class {
    @objc optional func mjViewController(_ viewController: MJViewController, didChangeSelectedIndex selectedIndex: Int)
    @objc optional func mjViewController(_ viewController: MJViewController, contentScrollViewDidScroll scrollView: UIScrollView)
    @objc optional func mjViewController(_ viewController: MJViewController, contentScrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func mjViewController(_ viewController: MJViewController, contentScrollViewDidEndDecelerating scrollView: UIScrollView)
    @objc optional func mjViewController(_ viewController: MJViewController, contentScrollViewWillBeginDragging scrollView: UIScrollView)
    
    
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidScroll scrollView: UIScrollView)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidZoom scrollView: UIScrollView)
    
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginDragging scrollView: UIScrollView)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginDecelerating scrollView: UIScrollView)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidEndDecelerating scrollView: UIScrollView)
    
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidEndScrollingAnimation scrollView: UIScrollView)
    
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView?
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool
    @objc optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidScrollToTop scrollView: UIScrollView)
}

@objc public protocol MJViewControllerDelegate: class, MJViewControllerScrollDelegate {
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: IndexPath)
    
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didHighlightRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: IndexPath)
    
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willSelectRowAtIndexPath indexPath: IndexPath) -> IndexPath?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willDeselectRowAtIndexPath indexPath: IndexPath) -> IndexPath?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCellEditingStyle
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: IndexPath) -> String?
    @objc @available(iOS 8.0, *)
    optional func mjViewController(_ viewController: MJViewController, selectedIndex: Int, tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]?
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: IndexPath) -> Bool
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: IndexPath) -> Int
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: IndexPath) -> Bool
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?) -> Bool
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?)
    
    @objc @available(iOS 9.0, *)
    optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, canFocusRowAtIndexPath indexPath: IndexPath) -> Bool
    @objc @available(iOS 9.0, *)
    optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool
    @objc @available(iOS 9.0, *)
    optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator)
    @objc @available(iOS 9.0, *)
    optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> IndexPath?
}
