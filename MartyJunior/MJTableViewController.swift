//
//  MJTableViewController.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MisterFusion

//MAKR: - MJDummyCell
private class MJDummyCell: UITableViewCell {}

//MARK: - MJTableViewController
public class MJTableViewController: UIViewController {
    //MARK: - Static constants
    private static let ReuseIdentifier = "MJDummyCell"
    
    //MARK: - Properties
    public let tableView = UITableView()
    weak var contentView: MJContentView?
    weak var delegate: MJTableViewControllerDelegate?
    weak var dataSource: MJTableViewControllerDataSource?
    private var cellHeightList: [String : CGFloat] = [:]
    private var headerHeightList: [String : CGFloat] = [:]
    private var footerHeightList: [String : CGFloat] = [:]
    
    private var dummyCellHeight: CGFloat {
        let cellHeight = cellHeightList.map{ $0.1 }.reduce(0, combine: +)
        let headerHeight = headerHeightList.map{ $0.1 }.reduce(0, combine: +)
        let footerHeight = footerHeightList.map{ $0.1 }.reduce(0, combine: +)
        let navigationContainerViewHeight = dataSource?.tableViewControllerHeaderHeight(self) ?? 0
        let maxmumHeight  = view.frame.size.height - navigationContainerViewHeight
        return min(maxmumHeight, max(0, maxmumHeight - (cellHeight + headerHeight + footerHeight)))
    }
    
    //MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addLayoutSubview(tableView, andConstraints:
            tableView.Top,
            tableView.Left,
            tableView.Right,
            tableView.Bottom
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(MJTableViewTopCell.self, forCellReuseIdentifier: MJTableViewTopCell.ReuseIdentifier)
        tableView.registerClass(MJDummyCell.self, forCellReuseIdentifier: MJTableViewController.ReuseIdentifier)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isDummySection(section: Int) -> Bool {
        return section == tableView.numberOfSections - 1
    }
}

//MARK: - UITableViewDataSource
extension MJTableViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !isDummySection(indexPath.section) {
            if indexPath.section == 0 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(MJTableViewTopCell.ReuseIdentifier) as! MJTableViewTopCell
                delegate?.tableViewController(self, tableViewTopCell: cell)
                return cell
            }
            
            if let cell = dataSource?.tableViewController(self, tableView: tableView, cellForRowAtIndexPath: indexPath) {
                return cell
            }
        }
        return tableView.dequeueReusableCellWithIdentifier(MJTableViewController.ReuseIdentifier)!
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || isDummySection(section) {
            return 1
        }
        return dataSource?.tableViewController(self, tableView: tableView, numberOfRowsInSection: section - 1) ?? 0
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let numberOfSections = dataSource?.tableViewController(self, numberOfSectionsInTableView: tableView) else {
            return 3
        }
        return numberOfSections + 2
    }

    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return nil }
        return dataSource?.tableViewController(self, tableView: tableView, titleForHeaderInSection: section - 1)
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 { return nil }
        return dataSource?.tableViewController(self, tableView: tableView, titleForFooterInSection: section - 1)
    }
   
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return dataSource?.tableViewController(self, tableView: tableView, canEditRowAtIndexPath: indexPath) ?? false
    }

    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return dataSource?.tableViewController(self, tableView: tableView, canMoveRowAtIndexPath: indexPath) ?? false
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        guard let titles = dataSource?.tableViewController(self, sectionIndexTitlesForTableView: tableView) else { return nil }
        return Array([[""], titles].flatten())
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return dataSource?.tableViewController(self, tableView: tableView, sectionForSectionIndexTitle: title, atIndex: index) ?? 0
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        dataSource?.tableViewController(self, tableView: tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }
 
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if (sourceIndexPath.section == 0 || destinationIndexPath.section == 0) { return }
        dataSource?.tableViewController(self, tableView: tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

//MARK: - UITableViewDelegate
extension MJTableViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        if isDummySection(indexPath.section) {
            height = dummyCellHeight
        } else if indexPath.section == 0 {
            height = delegate?.tableViewController(self, tableView: tableView, heightForTopCellAtIndexPath: indexPath) ?? 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForRowAtIndexPath: indexPath) ?? 44
            cellHeightList[indexPath.sectionRowString] = height
        }
        return height
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayHeaderView: view, forSection: section - 1)
    }

    public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayFooterView: view, forSection: section - 1)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingHeaderView: view, forSection: section - 1)
    }
    
    public func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingFooterView: view, forSection: section - 1)
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForHeaderInSection: section - 1) ?? 0
        }
        headerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForFooterInSection: section - 1) ?? 0
        }
        footerHeightList["\(section)"] = height
        return height
    }

    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        if isDummySection(indexPath.section) {
            height = dummyCellHeight
        } else if indexPath.section == 0 {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForTopCellAtIndexPath: indexPath) ?? 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForRowAtIndexPath: indexPath) ?? 0
            cellHeightList[indexPath.sectionRowString] = height
        }
        return height
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForHeaderInSection: section - 1) ?? 0
        }
        headerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForFooterInSection: section - 1) ?? 0
        }
        footerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, viewForHeaderInSection: section - 1)
    }

    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, viewForFooterInSection: section - 1)
    }
    
    public func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldHighlightRowAtIndexPath: indexPath) ?? true
    }
    
    public func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, willSelectRowAtIndexPath: indexPath) ?? indexPath
    }
    
    public func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, willDeselectRowAtIndexPath: indexPath) ?? indexPath
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 { return .None }
        return delegate?.tableViewController(self, tableView: tableView, editingStyleForRowAtIndexPath: indexPath) ?? .None
    }
    
    public func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        if indexPath.section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    }
    
    @available(iOS 8.0, *)
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, editActionsForRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath) ?? true
    }
    
    public func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willBeginEditingRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndEditingRowAtIndexPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section == 0 || proposedDestinationIndexPath.section == 0 {
            return NSIndexPath(forRow: 0, inSection: 0)
        }
        return delegate?.tableViewController(self, tableView: tableView, targetIndexPathForMoveFromRowAtIndexPath: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? NSIndexPath(forRow: 0, inSection: 1)
    }
    
    public func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 0 { return 0 }
        return delegate?.tableViewController(self, tableView: tableView, indentationLevelForRowAtIndexPath: indexPath) ?? 1
    }
    
    public func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldShowMenuForRowAtIndexPath: indexPath) ?? false
    }
    
    public func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if indexPath.section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender) ?? false
    }
    
    public func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if indexPath.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    public func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, canFocusRowAtIndexPath: indexPath) ?? true
    }
    
    @available(iOS 9.0, *)
    public func tableView(tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool {
        return delegate?.tableViewController(self, tableView: tableView, shouldUpdateFocusInContext: context) ?? true
    }
    
    @available(iOS 9.0, *)
    public func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        delegate?.tableViewController(self, tableView: tableView, didUpdateFocusInContext: context, withAnimationCoordinator: coordinator)
    }
    
    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedViewInTableView(tableView: UITableView) -> NSIndexPath? {
        return delegate?.tableViewController(self, indexPathForPreferredFocusedViewInTableView: tableView)
    }
}

//MARK: - UIScrollViewDelegate
extension MJTableViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidScroll: scrollView)
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidZoom: scrollView)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewWillBeginDragging: scrollView)
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.tableViewController(self, scrollViewWillEndDragging: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.tableViewController(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewWillBeginDecelerating: scrollView)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidEndDecelerating: scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidEndScrollingAnimation: scrollView)
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return delegate?.tableViewController(self, viewForZoomingInScrollView: scrollView)
    }
    
    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        delegate?.tableViewController(self, scrollViewWillBeginZooming: scrollView, withView: view)
    }
    
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        delegate?.tableViewController(self, scrollViewDidEndZooming: scrollView, withView: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return delegate?.tableViewController(self, scrollViewShouldScrollToTop: scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidScrollToTop: scrollView)
    }
}
