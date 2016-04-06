//
//  MJSlideViewController.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MisterFusion

public class MJViewController: UIViewController {
    //MARK: - Inner class
    private class RegisterCellContainer {
        struct NibAndIdentifierContainer {
            let nib: UINib?
            let reuseIdentifier: String
        }
        struct ClassAndIdentifierContainer {
            let aClass: AnyClass?
            let reuseIdentifier: String
        }
        var cellNib: [NibAndIdentifierContainer] = []
        var cellClass: [ClassAndIdentifierContainer] = []
        var headerFooterNib: [NibAndIdentifierContainer] = []
        var headerFooterClass: [ClassAndIdentifierContainer] = []
    }
    
    //MAKR: - Properties
    public weak var delegate: MJViewControllerDelegate?
    public weak var dataSource: MJViewControllerDataSource?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let scrollContainerView: UIView = UIView()
    private var scrollContainerViewWidthConstraint: NSLayoutConstraint?
    
    private let contentView: MJContentView = MJContentView()
    private let contentEscapeView: UIView = UIView()
    private var contentEscapeViewTopConstraint: NSLayoutConstraint?
    
    public private(set) var navigationView: MJNavigationView?
    private let navigationContainerView = UIView()
    
    private var containerViews: [UIView] = []
    private var viewControllers: [MJTableViewController] = []
    private let registerCellContainer: RegisterCellContainer = RegisterCellContainer()
    
    public var hiddenNavigationView: Bool = false
    
    public var tableViews: [UITableView] {
        return viewControllers.map { $0.tableView }
    }
    
    public private(set) var titles: [String]?
    public private(set) var numberOfTabs: Int = 0
    
    private var _selectedIndex: Int = 0 {
        didSet {
            delegate?.mjViewController?(self, didChangeSelectedIndex: _selectedIndex)
        }
    }
    public var selectedIndex: Int {
        get {
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
            if _selectedIndex != index {
                _selectedIndex = index
                viewControllers.enumerate().forEach { $0.element.tableView.scrollsToTop = $0.index == index }
            }
            return index
        }
        set {
            _selectedIndex = newValue
            addContentViewToEscapeView()
            UIView.animateWithDuration(0.25, animations: {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.size.width * CGFloat(newValue), y: 0), animated: false)
            }) { _ in
                if self.contentView.superview == self.contentEscapeView && self.scrollView.contentOffset.y < self.contentEscapeViewTopConstraint?.constant {
                    self.addContentViewToCell()
                }
            }
        }
    }
    
    public var headerHeight: CGFloat {
        return contentView.tabContainerView.frame.size.height + navigationContainerViewHeight
    }
    
    public var selectedViewController: MJTableViewController {
        return viewControllers[selectedIndex]
    }
    
    private var navigationContainerViewHeight: CGFloat {
        let sharedApplication = UIApplication.sharedApplication()
        let statusBarHeight = sharedApplication.statusBarHidden ? 0 : sharedApplication.statusBarFrame.size.height
        let navigationViewHeight: CGFloat = hiddenNavigationView ? 0 : 44
        return statusBarHeight + navigationViewHeight
    }
    
    private func indexOfViewController(viewController: MJTableViewController) -> Int {
        return viewControllers.indexOf(viewController) ?? 0
    }
    
    //MARK: - Life cycle
    public func viewWillSetupForMartyJunior() {}
    public func viewDidSetupForMartyJunior() {}
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewWillSetupForMartyJunior()
        
        guard let dataSource = dataSource else { return }
        titles = dataSource.mjViewControllerTitlesForTab?(self)
        numberOfTabs = dataSource.mjViewControllerNumberOfTabs(self)
        setupContentView(dataSource)
        setupScrollView()
        setupScrollContainerView()
        setupContainerViews()
        setupTableViewControllers()
        registerNibAndClassForTableViews()
        setupContentEscapeView()
        setNavigationView()
        
        viewDidSetupForMartyJunior()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       viewControllers.forEach { $0.tableView.reloadData() }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Setup views
extension MJViewController {
    private func setupContentView(dataSource: MJViewControllerDataSource) {
        contentView.titles = titles
        contentView.segmentedControl.selectedSegmentIndex = 0
        contentView.userDefinedView = dataSource.mjViewControllerContentViewForTop(self)
        contentView.userDefinedTabView = dataSource.mjViewControllerTabViewForTop?(self)
        contentView.setupTabView()
    }
    
    private func setupScrollView() {
        scrollView.scrollsToTop = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addLayoutSubview(scrollView, andConstraints:
            scrollView.Top,
            scrollView.Left,
            scrollView.Right,
            scrollView.Bottom
        )

    }
    
    private func setupScrollContainerView() {
        scrollContainerViewWidthConstraint = scrollView.addLayoutSubview(scrollContainerView, andConstraints:
            scrollContainerView.Top,
            scrollContainerView.Left,
            scrollContainerView.Right,
            scrollContainerView.Bottom,
            scrollContainerView.Height |==| scrollView.Height,
            scrollContainerView.Width |==| scrollView.Width |*| CGFloat(numberOfTabs)
        ).firstAttribute(.Width).first
    }
    
    private func setupContentEscapeView() {
        contentEscapeViewTopConstraint = view.addLayoutSubview(contentEscapeView, andConstraints:
            contentEscapeView.Top,
            contentEscapeView.Left,
            contentEscapeView.Right,
            contentEscapeView.Height |==| contentView.height
            ).firstAttribute(.Top).first
        
        view.layoutIfNeeded()
        
        contentEscapeView.backgroundColor = .clearColor()
        contentEscapeView.userInteractionEnabled = false
        contentEscapeView.hidden = true
    }
    
    private func setNavigationView() {
        view.addLayoutSubview(navigationContainerView, andConstraints:
            navigationContainerView.Top,
            navigationContainerView.Left,
            navigationContainerView.Right,
            navigationContainerView.Height |==| navigationContainerViewHeight
        )
        
        if hiddenNavigationView { return }
        let navigationView = MJNavigationView()
        navigationContainerView.addLayoutSubview(navigationView, andConstraints:
            navigationView.Height |==| MJNavigationView.Height,
            navigationView.Left,
            navigationView.Bottom,
            navigationView.Right
        )
        navigationView.titleLabel.text = title
        self.navigationView = navigationView
    }
    
    private func setupContainerViews() {
        (0..<numberOfTabs).forEach {
            let containerView = UIView()
            let misterFusions: [MisterFusion]
            switch $0 {
            case 0:
                misterFusions = [
                    containerView.Left,
                ]
                
            case (numberOfTabs - 1):
                guard let previousContainerView = containerViews.last else { return }
                misterFusions = [
                    containerView.Right,
                    containerView.Left |==| previousContainerView.Right,
                ]
                
            default:
                guard let previousContainerView = containerViews.last else { return }
                misterFusions = [
                    containerView.Left |==| previousContainerView.Right,
                ]
            }
            
            let commomMisterFusions = [
                containerView.Top,
                containerView.Bottom,
                containerView.Width |/| CGFloat(numberOfTabs)
            ]
            scrollContainerView.addLayoutSubview(containerView, andConstraints: misterFusions + commomMisterFusions)
            containerViews += [containerView]
        }
        contentView.delegate = self
    }
    
    private func setupTableViewControllers() {
        containerViews.forEach {
            let viewController = MJTableViewController()
            viewController.delegate = self
            viewController.dataSource = self
            viewController.contentView = self.contentView
            $0.addLayoutSubview(viewController.view, andConstraints:
                viewController.view.Top,
                viewController.view.Left,
                viewController.view.Right,
                viewController.view.Bottom
            )
            addChildViewController(viewController)
            viewController.didMoveToParentViewController(self)
            viewControllers += [viewController]
        }
    }
    
    private func registerNibAndClassForTableViews() {
        tableViews.forEach { tableView in
            registerCellContainer.cellNib.forEach { tableView.registerNib($0.nib, forCellReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.headerFooterNib.forEach { tableView.registerNib($0.nib, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.cellClass.forEach { tableView.registerClass($0.aClass, forCellReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.headerFooterClass.forEach { tableView.registerClass($0.aClass, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier) }
        }
    }
}

//MARK: - ContentView moving
extension MJViewController {
    private func addContentViewToCell() {
        if contentView.superview != contentEscapeView { return }
        
        contentEscapeView.hidden = true
        contentEscapeView.userInteractionEnabled = false
        
        let cells = selectedViewController.tableView.visibleCells.filter { $0.isKindOfClass(MJTableViewTopCell.self) }
        let cell = cells.first as? MJTableViewTopCell
        cell?.mainContentView = contentView
    }
    
    private func addContentViewToEscapeView() {
        if contentView.superview == contentEscapeView { return }
        
        contentEscapeView.hidden = false
        contentEscapeView.userInteractionEnabled = true
        
        contentEscapeView.addLayoutSubview(contentView, andConstraints:
            contentView.Top,
            contentView.Left,
            contentView.Right,
            contentView.Bottom
        )
        
        let topConstant = max(0, min(contentView.frame.size.height - headerHeight, selectedViewController.tableView.contentOffset.y))
        contentEscapeViewTopConstraint?.constant = -topConstant
        contentEscapeView.layoutIfNeeded()
    }
}

//MARK: - Private
extension MJViewController {
    private func setTableViewControllersContentOffsetBasedOnScrollView(scrollView: UIScrollView, withoutSelectedViewController: Bool) {
        let viewControllers = self.viewControllers.filter { $0 != selectedViewController }
        let contentHeight = contentView.frame.size.height - headerHeight
        viewControllers.forEach {
            let tableView = $0.tableView
            let contentOffset: CGPoint
            if scrollView.contentOffset.y <= contentHeight {
                contentOffset = scrollView.contentOffset
            } else {
                contentOffset = tableView.contentOffset.y >= contentHeight ? tableView.contentOffset : CGPoint(x: 0, y: contentHeight)
            }
            tableView.setContentOffset(contentOffset, animated: false)
        }
    }
}

//MARK: - Public
extension MJViewController {
    public func registerNibToAllTableViews(nib: UINib?, forCellReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.cellNib += [RegisterCellContainer.NibAndIdentifierContainer(nib: nib, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerNibToAllTableViews(nib: UINib?, forHeaderFooterViewReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.headerFooterNib += [RegisterCellContainer.NibAndIdentifierContainer(nib: nib, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerClassToAllTableViews(aClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.cellClass += [RegisterCellContainer.ClassAndIdentifierContainer(aClass: aClass, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerClassToAllTableViews(aClass: AnyClass?, forHeaderFooterViewReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.headerFooterClass += [RegisterCellContainer.ClassAndIdentifierContainer(aClass: aClass, reuseIdentifier: reuseIdentifier)]
    }
}

//MARK: - UIScrollViewDelegate
extension MJViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.mjViewController?(self, contentScrollViewDidScroll: scrollView)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollView.contentOffset.y < contentEscapeViewTopConstraint?.constant {
            addContentViewToCell()
        }
        contentView.segmentedControl.selectedSegmentIndex = selectedIndex
        delegate?.mjViewController?(self, contentScrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < contentEscapeViewTopConstraint?.constant {
            addContentViewToCell()
        }
        contentView.segmentedControl.selectedSegmentIndex = selectedIndex
        delegate?.mjViewController?(self, contentScrollViewDidEndDecelerating: scrollView)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        addContentViewToEscapeView()
        delegate?.mjViewController?(self, contentScrollViewWillBeginDragging: scrollView)
    }
}

//MARK: - MJTableViewControllerDataSource
extension MJViewController: MJTableViewControllerDataSource {
    func tableViewControllerHeaderHeight(viewController: MJTableViewController) -> CGFloat {
        return headerHeight
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell? {
        return dataSource?.mjViewController(self, targetIndex: indexOfViewController(viewController), tableView: tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, numberOfRowsInSection section: Int) -> Int? {
        return dataSource?.mjViewController(self, targetIndex: indexOfViewController(viewController), tableView: tableView, numberOfRowsInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, numberOfSectionsInTableView tableView: UITableView) -> Int? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), numberOfSectionsInTableView: tableView)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForHeaderInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForFooterInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canEditRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canMoveRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, sectionIndexTitlesForTableView tableView: UITableView) -> [String]? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), sectionIndexTitlesForTableView: tableView)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, sectionForSectionIndexTitle: title, atIndex: index)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

//MARK: - MJTableViewControllerDelegate
extension MJViewController: MJTableViewControllerDelegate {
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForTopCellAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return contentView.height
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForTopCellAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return contentView.height
    }
    
    func tableViewController(viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell) {
        if viewController != selectedViewController { return }
        if  contentView.superview != contentEscapeView {
            cell.mainContentView = contentView
        }
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        setTableViewControllersContentOffsetBasedOnScrollView(scrollView, withoutSelectedViewController: true)
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndDecelerating: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView) {
        if viewController != selectedViewController { return }

        if scrollView.contentOffset.y > contentView.frame.size.height - headerHeight {
            addContentViewToEscapeView()
        } else {
            addContentViewToCell()
        }
        
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidScroll: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if viewController != selectedViewController { return }
        setTableViewControllersContentOffsetBasedOnScrollView(scrollView, withoutSelectedViewController: true)
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    func tableViewController(viewController: MJTableViewController, scrollViewDidZoom scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidZoom: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewWillBeginDragging scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginDragging: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillEndDragging: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func tableViewController(viewController: MJTableViewController,  scrollViewWillBeginDecelerating scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginDecelerating: scrollView)
    }

    func tableViewController(viewController: MJTableViewController, scrollViewDidEndScrollingAnimation scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndScrollingAnimation: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView? {
        if viewController != selectedViewController { return nil }
        return delegate?.mjViewController?(self, selectedIndex: selectedIndex, viewForZoomingInScrollView: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginZooming: scrollView, withView: view)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndZooming: scrollView, withView: view, atScale: scale)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool? {
        if viewController != selectedViewController { return false }
        return delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewShouldScrollToTop: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidScrollToTop scrollView: UIScrollView) {
        viewControllers.filter { $0 != self.selectedViewController }.forEach { $0.tableView.setContentOffset(.zero, animated: false) }
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidScrollToTop: scrollView)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayFooterView: view, forSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForHeaderInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForFooterInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForFooterInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, viewForHeaderInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, viewForFooterInSection: section)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldHighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willSelectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDeselectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, editingStyleForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return delegate?.mjViewController?(self, selectedIndex: indexOfViewController(viewController), tableView: tableView, editActionsForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willBeginEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, targetIndexPathForMoveFromRowAtIndexPath: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldShowMenuForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canFocusRowAtIndexPath: indexPath)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldUpdateFocusInContext: context)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didUpdateFocusInContext: context, withAnimationCoordinator: coordinator)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(viewController: MJTableViewController, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> NSIndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), indexPathForPreferredFocusedViewInTableView: tableView)
    }
}

//MARK: - MJContentViewDelegate
extension MJViewController: MJContentViewDelegate {
    func contentView(contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl) {
        selectedIndex = segmentedControl.selectedSegmentIndex
    }
}
