//
//  ProfileViewController.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MartyJunior
import ReuseCellConfigure

class ProfileViewController: MJViewController {
    //MARK: - Properties
    private let layoutManager = ProfileViewLayoutManager()
    private let profileView = ProfileView.Nib.instantiateWithOwner(nil, options: nil).first as! ProfileView
    private let tabView = ProfileTabView.Nib.instantiateWithOwner(nil, options: nil).first as! ProfileTabView
    
    //MARK: - Life cycle
    override func viewWillSetupForMartyJunior() {
        super.viewWillSetupForMartyJunior()
        delegate = self
        dataSource = self
        registerNibToAllTableViews(ProfileTweetCell.Nib, forCellReuseIdentifier: ProfileTweetCell.ReuseIdentifier)
        registerNibToAllTableViews(ProfileUserCell.Nib, forCellReuseIdentifier: ProfileUserCell.ReuseIdentifier)
        
        tabView.delegate = self
        
        title = "@szk-atmosphere"
    }
    
    override func viewDidSetupForMartyJunior() {
        super.viewDidSetupForMartyJunior()
        navigationView?.titleLabel.alpha = 0
        navigationView?.rightButton = UIButton(type: .InfoDark)
        navigationView?.rightButton?.tintColor = .whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: MJViewControllerDataSource {
    func mjViewControllerContentViewForTop(viewController: MJViewController) -> UIView {
        return profileView
    }
    
    func mjViewControllerTabViewForTop(viewController: MJViewController) -> UIView {
        return tabView
    }
    
    func mjViewController(viewController: MJViewController, didChangeSelectedIndex selectedIndex: Int) {
        tabView.selectedIndex = selectedIndex
    }
    
    func mjViewControllerNumberOfTabs(viewController: MJViewController) -> Int {
        return ProfileViewLayoutManager.TabTypes.count
    }
    
    func mjViewControllerTitlesForTab(viewController: MJViewController) -> [String] {
        return ProfileViewLayoutManager.TabTypes.map { $0.rawValue }
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return layoutManager.cellForTargetIndex(targetIndex, indexPath: indexPath, tableView: tableView)
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutManager.numberOfRowsInTargetIndex(targetIndex)
    }
}

extension ProfileViewController: MJViewControllerDelegate {
    func mjViewController(viewController: MJViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        tabView.syncOtherScrollView(scrollView)
    }
    
    func mjViewController(viewController: MJViewController, selectedIndex: Int, scrollViewDidScroll scrollView: UIScrollView) {
        let value = min(1, max(0, scrollView.contentOffset.y / headerHeight))
        profileView.backgroundImageView.blur(value)
        profileView.userIconImageView.alpha = 1 - value
        profileView.textView.alpha = 1 - value
        profileView.followButton.alpha = 1 - value
        navigationView?.titleLabel.alpha = value
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return layoutManager.heightForTargetIndex(targetIndex)
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("targetIndex = \(targetIndex) indexPath = \(indexPath)")
    }
}

extension ProfileViewController: ProfileTabViewDelegate {
    func profileTabView(view: ProfileTabView, didTapTab button: UIButton, index: Int) {
        selectedIndex = index
    }
}