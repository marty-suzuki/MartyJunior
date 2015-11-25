//
//  MJTableViewController.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/11/26.
//
//

import UIKit
import MisterFusion

protocol MJTableViewControllerDelegate: class {
    func tableViewController(viewController: MJTableViewController, scrollViewDidScroll scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDecelerating scrollView: UIScrollView)
    func tableViewController(viewController: MJTableViewController, scrollViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func tableViewController(viewController: MJTableViewController, tableViewTopCell cell: MJTableViewTopCell)
}

public class MJTableViewController: UIViewController {
    
    public let tableView: UITableView = UITableView()
    
    weak var delegate: MJTableViewControllerDelegate?
    
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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MJTableViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(MJTableViewTopCell.ReuseIdentifier) as! MJTableViewTopCell
            delegate?.tableViewController(self, tableViewTopCell: cell)
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("Cell")!
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 30
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
}

extension MJTableViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return MJContentView.Height
        }
        return 44
    }
}

extension MJTableViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidScroll: scrollView)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.tableViewController(self, scrollViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.tableViewController(self, scrollViewDidEndDecelerating: scrollView)
    }
}
