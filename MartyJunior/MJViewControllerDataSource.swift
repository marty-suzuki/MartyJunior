//
//  MJViewControllerDataSource.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

@objc public protocol MJViewControllerDataSource: class {
    func mjViewControllerNumberOfTabs(viewController: MJViewController) -> Int
    func mjViewControllerContentViewForTop(viewController: MJViewController) -> UIView
    optional func mjViewControllerTabViewForTop(viewController: MJViewController) -> UIView
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    optional func mjViewControllerTitlesForTab(viewController: MJViewController) -> [String]
    
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, numberOfSectionsInTableView tableView: UITableView) -> Int
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForFooterInSection section: Int) -> String?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, sectionIndexTitlesForTableView tableView: UITableView) -> [String]?
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    optional func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
}