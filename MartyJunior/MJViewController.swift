//
//  MJSlideViewController.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/11/26.
//
//

import UIKit
import MisterFusion

public class MJViewController: UIViewController {

    let scrollView: UIScrollView = UIScrollView()
    private let scrollContainerView: UIView = UIView()
    private var scrollContainerViewWidthConstraint: NSLayoutConstraint?
    
    private var contentView: MJContentView = MJContentView()
    private var contentViewTopConstraint: NSLayoutConstraint?
    private var contentEscapeView: UIView = UIView()
    
    private var containerViews: [UIView] = []
    private var viewControllers: [MJTableViewController] = []
    
    public var numberOfTabs: Int = 3 {
        didSet {
            guard let scrollContainerViewWidthConstraint = scrollContainerViewWidthConstraint else { return }
            scrollView.removeConstraint(scrollContainerViewWidthConstraint)
            self.scrollContainerViewWidthConstraint = scrollView.addLayoutConstraint(scrollContainerView.Width |==| view.Width |*| CGFloat(numberOfTabs))
        }
    }
    
    public var selectedIndex: Int {
        return Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
    
    public var selectedViewController: MJTableViewController {
        return viewControllers[selectedIndex]
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        view.addLayoutSubview(scrollView, andConstraints:
            scrollView.Top,
            scrollView.Left,
            scrollView.Right,
            scrollView.Bottom
        )
        
        scrollContainerViewWidthConstraint = scrollView.addLayoutSubview(scrollContainerView, andConstraints:
            scrollContainerView.Top,
            scrollContainerView.Left,
            scrollContainerView.Right,
            scrollContainerView.Bottom,
            scrollContainerView.Height |==| scrollView.Height,
            scrollContainerView.Width |==| scrollView.Width |*| CGFloat(numberOfTabs)
        ).firstAttribute(.Width).first
        
        setupContainerViews()
        setupTableViewControllers()
        
        view.addLayoutSubview(contentEscapeView, andConstraints:
            contentEscapeView.Top,
            contentEscapeView.Left,
            contentEscapeView.Right,
            contentEscapeView.Height |=| MJContentView.Height
        )
        contentEscapeView.backgroundColor = .clearColor()
        contentEscapeView.userInteractionEnabled = false
        contentEscapeView.hidden = true
    }
    
    private func setupContainerViews() {
        for index in 0..<numberOfTabs {
            let containerView = UIView()
            let misterFusions: [MisterFusion]
            switch index {
            case 0:
                misterFusions = [
                    containerView.Left,
                ]
                
            case (numberOfTabs - 1):
                guard let previousContainerView = containerViews.last else { continue }
                misterFusions = [
                    containerView.Right,
                    containerView.Left |==| previousContainerView.Right,
                ]
                
            default:
                guard let previousContainerView = containerViews.last else { continue }
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
        for containerView in containerViews {
            let viewController = MJTableViewController()
            viewController.delegate = self
            containerView.addLayoutSubview(viewController.view, andConstraints:
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

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addContentViewToCell() {
        contentEscapeView.hidden = true
        contentViewTopConstraint = nil
        
        let cells = selectedViewController.tableView.visibleCells.filter { $0.isKindOfClass(MJTableViewTopCell.self) }
        let cell = cells.first as? MJTableViewTopCell
        cell?.mainContentView = contentView
        contentView.segmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    func addContentViewToEscapeView() {
        contentEscapeView.hidden = false
        contentViewTopConstraint = contentEscapeView
            .addLayoutSubview(contentView, andConstraints:
                contentView.Top |-| selectedViewController.tableView.contentOffset.y,
                contentView.Left,
                contentView.Right,
                contentView.Height |=| MJContentView.Height
            ).firstAttribute(.Top).first
    }
}

extension MJViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {

    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if contentView.superview == contentEscapeView && !decelerate {
            addContentViewToCell()
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if contentView.superview == contentEscapeView {
            addContentViewToCell()
        }
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if contentView.superview != contentEscapeView {
            addContentViewToEscapeView()
        }
    }
}

extension MJViewController: MJTableViewControllerDelegate {
    func tableViewController(viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell) {
        if viewController != selectedViewController { return }
        cell.mainContentView = contentView
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView) {
        let viewControllers = self.viewControllers.filter { $0 != selectedViewController }
        for vc in viewControllers {
            vc.tableView.setContentOffset(scrollView.contentOffset, animated: false)
        }
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView) {
        
    }
    
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let viewControllers = self.viewControllers.filter { $0 != selectedViewController }
        for vc in viewControllers {
            vc.tableView.setContentOffset(scrollView.contentOffset, animated: false)
        }
    }
}

extension MJViewController: MJContentViewDelegate {
    func contentView(contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl) {
        addContentViewToEscapeView()
        UIView.animateWithDuration(0.25, animations: {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.size.width * CGFloat(segmentedControl.selectedSegmentIndex), y: 0), animated: false)
        }) { finished in
            self.addContentViewToCell()
        }
    }
}
