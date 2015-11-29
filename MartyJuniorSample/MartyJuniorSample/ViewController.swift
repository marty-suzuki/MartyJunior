//
//  ViewController.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MartyJunior

class ViewController: MJViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        dataSource = self
        
        registerClassToAllTableViews(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MJViewControllerDataSource {
    func mjViewControllerTitlesForTab(viewController: MJViewController) -> [String] {
        return ["Part1", "Part2", "Part3", "Part4"]
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        switch targetIndex % 3 {
        case 1:
            cell.contentView.backgroundColor = .redColor()
        case 2:
            cell.contentView.backgroundColor = .greenColor()
        case 3:
            cell.contentView.backgroundColor = .brownColor()
        default:
            cell.contentView.backgroundColor = .yellowColor()
        }
        return cell
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
}

extension ViewController: MJViewControllerDelegate {
    func mjViewController(viewController: MJViewController, selectedIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
}