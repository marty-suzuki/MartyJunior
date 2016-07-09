//
//  MJViewControllerDataSource.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

@objc public protocol MJViewControllerDataSource: class {
    func mjViewControllerNumberOfTabs(_ viewController: MJViewController) -> Int
    func mjViewControllerContentViewForTop(_ viewController: MJViewController) -> UIView
    @objc optional func mjViewControllerTabViewForTop(_ viewController: MJViewController) -> UIView
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    @objc optional func mjViewControllerTitlesForTab(_ viewController: MJViewController) -> [String]
    
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, numberOfSectionsInTableView tableView: UITableView) -> Int
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, titleForFooterInSection section: Int) -> String?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, sectionIndexTitlesForTableView tableView: UITableView) -> [String]?
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    @objc optional func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, moveRowAtIndexPath sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath)
}
