//
//  MJTableViewControllerDataSource.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

protocol MJTableViewControllerDataSource: class {
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, numberOfRowsInSection section: Int) -> Int?
    func tableViewController(viewController: MJTableViewController, numberOfSectionsInTableView tableView: UITableView) -> Int?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, titleForFooterInSection section: Int) -> String?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool?
    func tableViewController(viewController: MJTableViewController, sectionIndexTitlesForTableView tableView: UITableView) -> [String]?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int?
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    func tableViewController(viewController: MJTableViewController, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    func tableViewControllerHeaderHeight(viewController: MJTableViewController) -> CGFloat
}