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
open class MJTableViewController: UIViewController {
    //MARK: - Static constants
    fileprivate static let reuseIdentifier = "MJDummyCell"
    
    //MARK: - Properties
    public let tableView = UITableView()
    weak var contentView: MJContentView?
    weak var delegate: MJTableViewControllerDelegate?
    weak var dataSource: MJTableViewControllerDataSource?
    fileprivate var cellHeightList: [String : CGFloat] = [:]
    fileprivate var headerHeightList: [String : CGFloat] = [:]
    fileprivate var footerHeightList: [String : CGFloat] = [:]
    
    fileprivate var dummyCellHeight: CGFloat {
        let cellHeight = cellHeightList.map{ $0.1 }.reduce(0, +)
        let headerHeight = headerHeightList.map{ $0.1 }.reduce(0, +)
        let footerHeight = footerHeightList.map{ $0.1 }.reduce(0, +)
        let navigationContainerViewHeight = dataSource?.tableViewControllerHeaderHeight(self) ?? 0
        let maxmumHeight  = view.frame.size.height - navigationContainerViewHeight
        return min(maxmumHeight, max(0, maxmumHeight - (cellHeight + headerHeight + footerHeight)))
    }
    
    //MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addLayoutSubview(tableView, andConstraints:
            tableView.top,
            tableView.left,
            tableView.right,
            tableView.bottom
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MJTableViewTopCell.self, forCellReuseIdentifier: MJTableViewTopCell.ReuseIdentifier)
        tableView.register(MJDummyCell.self, forCellReuseIdentifier: MJTableViewController.reuseIdentifier)
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func isDummySection(_ section: Int) -> Bool {
        return section == tableView.numberOfSections - 1
    }
}

//MARK: - UITableViewDataSource
extension MJTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isDummySection(indexPath.section) {
            if (indexPath as NSIndexPath).section == 0 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MJTableViewTopCell.ReuseIdentifier) as! MJTableViewTopCell
                delegate?.tableViewController(self, tableViewTopCell: cell)
                return cell
            }
            
            if let cell = dataSource?.tableViewController(self, tableView: tableView, cellForRowAtIndexPath: indexPath) {
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: MJTableViewController.reuseIdentifier)!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || isDummySection(section) {
            return 1
        }
        return dataSource?.tableViewController(self, tableView: tableView, numberOfRowsInSection: section - 1) ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSections = dataSource?.tableViewController(self, numberOfSectionsInTableView: tableView) else {
            return 3
        }
        return numberOfSections + 2
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return nil }
        return dataSource?.tableViewController(self, tableView: tableView, titleForHeaderInSection: section - 1)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 { return nil }
        return dataSource?.tableViewController(self, tableView: tableView, titleForFooterInSection: section - 1)
    }
   
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return dataSource?.tableViewController(self, tableView: tableView, canEditRowAtIndexPath: indexPath) ?? false
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return dataSource?.tableViewController(self, tableView: tableView, canMoveRowAtIndexPath: indexPath) ?? false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard let titles = dataSource?.tableViewController(self, sectionIndexTitlesForTableView: tableView) else { return nil }
        return Array([[""], titles].joined())
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return dataSource?.tableViewController(self, tableView: tableView, sectionForSectionIndexTitle: title, atIndex: index) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        dataSource?.tableViewController(self, tableView: tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }
 
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if ((sourceIndexPath as NSIndexPath).section == 0 || (destinationIndexPath as NSIndexPath).section == 0) { return }
        dataSource?.tableViewController(self, tableView: tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

//MARK: - UITableViewDelegate
extension MJTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat
        if isDummySection(indexPath.section) {
            height = dummyCellHeight
        } else if (indexPath as NSIndexPath).section == 0 {
            height = delegate?.tableViewController(self, tableView: tableView, heightForTopCellAtIndexPath: indexPath) ?? 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForRowAtIndexPath: indexPath) ?? 44
            cellHeightList[indexPath.sectionRowString] = height
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayHeaderView: view, forSection: section - 1)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willDisplayFooterView: view, forSection: section - 1)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingHeaderView: view, forSection: section - 1)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndDisplayingFooterView: view, forSection: section - 1)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForHeaderInSection: section - 1) ?? 0
        }
        headerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, heightForFooterInSection: section - 1) ?? 0
        }
        footerHeightList["\(section)"] = height
        return height
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat
        if isDummySection(indexPath.section) {
            height = dummyCellHeight
        } else if (indexPath as NSIndexPath).section == 0 {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForTopCellAtIndexPath: indexPath) ?? 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForRowAtIndexPath: indexPath) ?? 0
            cellHeightList[indexPath.sectionRowString] = height
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForHeaderInSection: section - 1) ?? 0
        }
        headerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let height: CGFloat
        if section == 0 || isDummySection(section) {
            height = 0
        } else {
            height = delegate?.tableViewController(self, tableView: tableView, estimatedHeightForFooterInSection: section - 1) ?? 0
        }
        footerHeightList["\(section)"] = height
        return height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, viewForHeaderInSection: section - 1)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, viewForFooterInSection: section - 1)
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldHighlightRowAtIndexPath: indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath as NSIndexPath).section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, willSelectRowAtIndexPath: indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath as NSIndexPath).section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, willDeselectRowAtIndexPath: indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (indexPath as NSIndexPath).section == 0 { return .none }
        return delegate?.tableViewController(self, tableView: tableView, editingStyleForRowAtIndexPath: indexPath) ?? .none
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if (indexPath as NSIndexPath).section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    }
    
    @available(iOS 8.0, *)
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (indexPath as NSIndexPath).section == 0 { return nil }
        return delegate?.tableViewController(self, tableView: tableView, editActionsForRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath) ?? true
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, willBeginEditingRowAtIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if indexPath?.section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, didEndEditingRowAtIndexPath: indexPath!)
    }
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (sourceIndexPath as NSIndexPath).section == 0 || (proposedDestinationIndexPath as NSIndexPath).section == 0 {
            return IndexPath(row: 0, section: 0)
        }
        return delegate?.tableViewController(self, tableView: tableView, targetIndexPathForMoveFromRowAtIndexPath: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? IndexPath(row: 0, section: 1)
    }
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if (indexPath as NSIndexPath).section == 0 { return 0 }
        return delegate?.tableViewController(self, tableView: tableView, indentationLevelForRowAtIndexPath: indexPath) ?? 1
    }
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, shouldShowMenuForRowAtIndexPath: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: AnyObject?) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender) ?? false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: AnyObject?) {
        if (indexPath as NSIndexPath).section == 0 { return }
        delegate?.tableViewController(self, tableView: tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 { return false }
        return delegate?.tableViewController(self, tableView: tableView, canFocusRowAtIndexPath: indexPath) ?? true
    }
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return delegate?.tableViewController(self, tableView: tableView, shouldUpdateFocusInContext: context) ?? true
    }
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        delegate?.tableViewController(self, tableView: tableView, didUpdateFocusInContext: context, withAnimationCoordinator: coordinator)
    }
    
    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return delegate?.tableViewController(self, indexPathForPreferredFocusedViewInTableView: tableView)
    }
}

//MARK: - UIScrollViewDelegate
extension MJTableViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidScroll: scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidZoom: scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewWillBeginDragging: scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.tableViewController(self, scrollViewWillEndDragging: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.tableViewController(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewWillBeginDecelerating: scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidEndDecelerating: scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidEndScrollingAnimation: scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.tableViewController(self, viewForZoomingInScrollView: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.tableViewController(self, scrollViewWillBeginZooming: scrollView, withView: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.tableViewController(self, scrollViewDidEndZooming: scrollView, withView: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.tableViewController(self, scrollViewShouldScrollToTop: scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidScrollToTop: scrollView)
    }
}
