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
    func mjViewController(viewController: MJViewController, selectedIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        switch selectedIndex % 3 {
        case 1:
            cell.contentView.backgroundColor = .redColor()
        case 2:
            cell.contentView.backgroundColor = .greenColor()
        default:
            cell.contentView.backgroundColor = .yellowColor()
        }
        return cell
    }
    
    func mjViewController(viewController: MJViewController, selectedIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
}

extension ViewController: MJViewControllerDelegate {
    
}