//
//  MJSlideViewController.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MisterFusion

open class MJViewController: UIViewController {
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
    
    fileprivate let contentView: MJContentView = MJContentView()
    fileprivate let contentEscapeView: UIView = UIView()
    fileprivate var contentEscapeViewTopConstraint: NSLayoutConstraint?
    
    public private(set) var navigationView: MJNavigationView?
    private let navigationContainerView = UIView()
    
    private var containerViews: [UIView] = []
    fileprivate var viewControllers: [MJTableViewController] = []
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
                viewControllers.enumerated().forEach { $0.element.tableView.scrollsToTop = $0.offset == index }
            }
            return index
        }
        set {
            _selectedIndex = newValue
            addContentViewToEscapeView()
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.size.width * CGFloat(newValue), y: 0), animated: false)
            }) { _ in
                if let superview = self.contentView.superview, let constant = self.contentEscapeViewTopConstraint?.constant,
                   superview == self.contentEscapeView && self.scrollView.contentOffset.y < constant {
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
        let sharedApplication = UIApplication.shared
        let statusBarHeight = sharedApplication.isStatusBarHidden ? 0 : sharedApplication.statusBarFrame.size.height
        let navigationViewHeight: CGFloat = hiddenNavigationView ? 0 : 44
        return statusBarHeight + navigationViewHeight
    }
    
    fileprivate func indexOfViewController(_ viewController: MJTableViewController) -> Int {
        return viewControllers.index(of: viewController) ?? 0
    }
    
    //MARK: - Life cycle
    open func viewWillSetupForMartyJunior() {}
    open func viewDidSetupForMartyJunior() {}
    
    open override func viewDidLoad() {
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
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       viewControllers.forEach { $0.tableView.reloadData() }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup views
    private func setupContentView(_ dataSource: MJViewControllerDataSource) {
        contentView.titles = titles
        contentView.segmentedControl.selectedSegmentIndex = 0
        contentView.userDefinedView = dataSource.mjViewControllerContentViewForTop(self)
        contentView.userDefinedTabView = dataSource.mjViewControllerTabViewForTop?(self)
        contentView.setupTabView()
    }
    
    private func setupScrollView() {
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addLayoutSubview(scrollView, andConstraints:
            scrollView.top,
            scrollView.left,
            scrollView.right,
            scrollView.bottom
        )

    }
    
    private func setupScrollContainerView() {
        scrollContainerViewWidthConstraint = scrollView.addLayoutSubview(scrollContainerView, andConstraints:
            scrollContainerView.top,
            scrollContainerView.left,
            scrollContainerView.right,
            scrollContainerView.bottom,
            scrollContainerView.height |==| scrollView.height,
            scrollContainerView.width |==| scrollView.width |*| CGFloat(numberOfTabs)
        ).firstAttribute(.width).first
    }
    
    private func setupContentEscapeView() {
        contentEscapeViewTopConstraint = view.addLayoutSubview(contentEscapeView, andConstraints:
            contentEscapeView.top,
            contentEscapeView.left,
            contentEscapeView.right,
            contentEscapeView.height |==| contentView.currentHeight
        ).firstAttribute(.top).first
        
        view.layoutIfNeeded()
        
        contentEscapeView.backgroundColor = .clear
        contentEscapeView.isUserInteractionEnabled = false
        contentEscapeView.isHidden = true
    }
    
    private func setNavigationView() {
        view.addLayoutSubview(navigationContainerView, andConstraints:
            navigationContainerView.top,
            navigationContainerView.left,
            navigationContainerView.right,
            navigationContainerView.height |==| navigationContainerViewHeight
        )
        
        if hiddenNavigationView { return }
        let navigationView = MJNavigationView()
        navigationContainerView.addLayoutSubview(navigationView, andConstraints:
            navigationView.height |==| MJNavigationView.Height,
            navigationView.left,
            navigationView.bottom,
            navigationView.right
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
                    containerView.left,
                ]
                
            case (numberOfTabs - 1):
                guard let previousContainerView = containerViews.last else { return }
                misterFusions = [
                    containerView.right,
                    containerView.left |==| previousContainerView.right,
                ]
                
            default:
                guard let previousContainerView = containerViews.last else { return }
                misterFusions = [
                    containerView.left |==| previousContainerView.right,
                ]
            }
            
            let commomMisterFusions = [
                containerView.top,
                containerView.bottom,
                containerView.width |/| CGFloat(numberOfTabs)
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
                viewController.view.top,
                viewController.view.left,
                viewController.view.right,
                viewController.view.bottom
            )
            addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            viewControllers += [viewController]
        }
    }
    
    private func registerNibAndClassForTableViews() {
        tableViews.forEach { tableView in
            registerCellContainer.cellNib.forEach { tableView.register($0.nib, forCellReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.headerFooterNib.forEach { tableView.register($0.nib, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.cellClass.forEach { tableView.register($0.aClass, forCellReuseIdentifier: $0.reuseIdentifier) }
            registerCellContainer.headerFooterClass.forEach { tableView.register($0.aClass, forHeaderFooterViewReuseIdentifier: $0.reuseIdentifier) }
        }
    }

    //MARK: - ContentView moving
    fileprivate func addContentViewToCell() {
        if contentView.superview != contentEscapeView { return }
        
        contentEscapeView.isHidden = true
        contentEscapeView.isUserInteractionEnabled = false
        
        let cells = selectedViewController.tableView.visibleCells.filter { $0.isKind(of: MJTableViewTopCell.self) }
        let cell = cells.first as? MJTableViewTopCell
        cell?.mainContentView = contentView
    }
    
    fileprivate func addContentViewToEscapeView() {
        if contentView.superview == contentEscapeView { return }
        
        contentEscapeView.isHidden = false
        contentEscapeView.isUserInteractionEnabled = true
        
        contentEscapeView.addLayoutSubview(contentView, andConstraints:
            contentView.top,
            contentView.left,
            contentView.right,
            contentView.bottom
        )
        
        let topConstant = max(0, min(contentView.frame.size.height - headerHeight, selectedViewController.tableView.contentOffset.y))
        contentEscapeViewTopConstraint?.constant = -topConstant
        contentEscapeView.layoutIfNeeded()
    }

    //MARK: - Private
    fileprivate func setTableViewControllersContentOffsetBasedOnScrollView(_ scrollView: UIScrollView, withoutSelectedViewController: Bool) {
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

    //MARK: - Public
    public func registerNibToAllTableViews(_ nib: UINib?, forCellReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.cellNib += [RegisterCellContainer.NibAndIdentifierContainer(nib: nib, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerNibToAllTableViews(_ nib: UINib?, forHeaderFooterViewReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.headerFooterNib += [RegisterCellContainer.NibAndIdentifierContainer(nib: nib, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerClassToAllTableViews(_ aClass: AnyClass?, forCellReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.cellClass += [RegisterCellContainer.ClassAndIdentifierContainer(aClass: aClass, reuseIdentifier: reuseIdentifier)]
    }
    
    public func registerClassToAllTableViews(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier reuseIdentifier: String) {
        registerCellContainer.headerFooterClass += [RegisterCellContainer.ClassAndIdentifierContainer(aClass: aClass, reuseIdentifier: reuseIdentifier)]
    }
}

//MARK: - UIScrollViewDelegate
extension MJViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.mjViewController?(self, contentScrollViewDidScroll: scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let constant = contentEscapeViewTopConstraint?.constant, !decelerate && scrollView.contentOffset.y < constant {
            addContentViewToCell()
        }
        contentView.segmentedControl.selectedSegmentIndex = selectedIndex
        delegate?.mjViewController?(self, contentScrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let constant = contentEscapeViewTopConstraint?.constant, scrollView.contentOffset.y < constant {
            addContentViewToCell()
        }
        contentView.segmentedControl.selectedSegmentIndex = selectedIndex
        delegate?.mjViewController?(self, contentScrollViewDidEndDecelerating: scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        addContentViewToEscapeView()
        delegate?.mjViewController?(self, contentScrollViewWillBeginDragging: scrollView)
    }
}

//MARK: - MJTableViewControllerDataSource
extension MJViewController: MJTableViewControllerDataSource {
    func tableViewControllerHeaderHeight(_ viewController: MJTableViewController) -> CGFloat {
        return headerHeight
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
        return dataSource?.mjViewController(self, targetIndex: indexOfViewController(viewController), tableView: tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, numberOfRowsInSection section: Int) -> Int? {
        return dataSource?.mjViewController(self, targetIndex: indexOfViewController(viewController), tableView: tableView, numberOfRowsInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, numberOfSectionsInTableView tableView: UITableView) -> Int? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), numberOfSectionsInTableView: tableView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForHeaderInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForFooterInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canEditRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canMoveRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, sectionIndexTitlesForTableView tableView: UITableView) -> [String]? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), sectionIndexTitlesForTableView: tableView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int? {
        return dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, sectionForSectionIndexTitle: title, atIndex: index)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, commitEditingStyle: editingStyle, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath) {
        dataSource?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

//MARK: - MJTableViewControllerDelegate
extension MJViewController: MJTableViewControllerDelegate {
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForTopCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return contentView.currentHeight
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForTopCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return contentView.currentHeight
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell) {
        if viewController != selectedViewController { return }
        if  contentView.superview != contentEscapeView {
            cell.mainContentView = contentView
        }
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        setTableViewControllersContentOffsetBasedOnScrollView(scrollView, withoutSelectedViewController: true)
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndDecelerating: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView) {
        if viewController != selectedViewController { return }

        if scrollView.contentOffset.y > contentView.frame.size.height - headerHeight {
            addContentViewToEscapeView()
        } else {
            addContentViewToCell()
        }
        
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidScroll: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if viewController != selectedViewController { return }
        setTableViewControllersContentOffsetBasedOnScrollView(scrollView, withoutSelectedViewController: true)
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    func tableViewController(_ viewController: MJTableViewController, scrollViewDidZoom scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidZoom: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillBeginDragging scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginDragging: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillEndDragging scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillEndDragging: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func tableViewController(_ viewController: MJTableViewController,  scrollViewWillBeginDecelerating scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginDecelerating: scrollView)
    }

    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndScrollingAnimation scrollView: UIScrollView) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndScrollingAnimation: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, viewForZoomingInScrollView scrollView: UIScrollView) -> UIView? {
        if viewController != selectedViewController { return nil }
        return delegate?.mjViewController?(self, selectedIndex: selectedIndex, viewForZoomingInScrollView: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewWillBeginZooming scrollView: UIScrollView, withView view: UIView?) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewWillBeginZooming: scrollView, withView: view)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidEndZooming scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidEndZooming: scrollView, withView: view, atScale: scale)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewShouldScrollToTop scrollView: UIScrollView) -> Bool? {
        if viewController != selectedViewController { return false }
        return delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewShouldScrollToTop: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, scrollViewDidScrollToTop scrollView: UIScrollView) {
        viewControllers.filter { $0 != self.selectedViewController }.forEach { $0.tableView.setContentOffset(.zero, animated: false) }
        if viewController != selectedViewController { return }
        delegate?.mjViewController?(self, selectedIndex: selectedIndex, scrollViewDidScrollToTop: scrollView)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDisplayFooterView: view, forSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingCell: cell, forRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForHeaderInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, heightForFooterInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, estimatedHeightForFooterInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, viewForHeaderInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, viewForFooterInSection: section)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, accessoryButtonTappedForRowWithIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldHighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didHighlightRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didHighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didUnhighlightRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willSelectRowAtIndexPath indexPath: IndexPath) -> IndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willSelectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willDeselectRowAtIndexPath indexPath: IndexPath) -> IndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willDeselectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCellEditingStyle? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, editingStyleForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: IndexPath) -> String? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]? {
        return delegate?.mjViewController?(self, selectedIndex: indexOfViewController(viewController), tableView: tableView, editActionsForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldIndentWhileEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, willBeginEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didEndEditingRowAtIndexPath indexPath: IndexPath) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didEndEditingRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, targetIndexPathForMoveFromRowAtIndexPath: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: IndexPath) -> Int? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldShowMenuForRowAtIndexPath: indexPath)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canPerformAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: IndexPath, withSender sender: AnyObject?) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, performAction: action, forRowAtIndexPath: indexPath, withSender: sender)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canFocusRowAtIndexPath indexPath: IndexPath) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, canFocusRowAtIndexPath: indexPath)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, shouldUpdateFocusInContext context: UITableViewFocusUpdateContext) -> Bool? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, shouldUpdateFocusInContext: context)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), tableView: tableView, didUpdateFocusInContext: context, withAnimationCoordinator: coordinator)
    }
    
    @available(iOS 9.0, *)
    func tableViewController(_ viewController: MJTableViewController, indexPathForPreferredFocusedViewInTableView tableView: UITableView) -> IndexPath? {
        return delegate?.mjViewController?(self, targetIndex: indexOfViewController(viewController), indexPathForPreferredFocusedViewInTableView: tableView)
    }
}

//MARK: - MJContentViewDelegate
extension MJViewController: MJContentViewDelegate {
    func contentView(_ contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl) {
        selectedIndex = segmentedControl.selectedSegmentIndex
    }
}
