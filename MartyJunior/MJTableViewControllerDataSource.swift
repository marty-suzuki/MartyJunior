//
//  MJTableViewControllerDataSource.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

protocol MJTableViewControllerDataSource: class {
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, numberOfRowsInSection section: Int) -> Int?
    func tableViewController(_ viewController: MJTableViewController, numberOfSectionsInTableView tableView: UITableView) -> Int?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, titleForFooterInSection section: Int) -> String?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool?
    func tableViewController(_ viewController: MJTableViewController, sectionIndexTitlesForTableView tableView: UITableView) -> [String]?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int?
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    func tableViewController(_ viewController: MJTableViewController, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath)
    func tableViewControllerHeaderHeight(_ viewController: MJTableViewController) -> CGFloat
}
