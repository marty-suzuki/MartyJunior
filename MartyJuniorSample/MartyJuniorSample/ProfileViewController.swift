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
    private let profileView = ProfileView.Nib.instantiate(withOwner: nil, options: nil).first as! ProfileView
    private let tabView = ProfileTabView.Nib.instantiate(withOwner: nil, options: nil).first as! ProfileTabView
    
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
        navigationView?.rightButton = UIButton(type: .infoDark)
        navigationView?.rightButton?.tintColor = .white()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: MJViewControllerDataSource {
    func mjViewControllerContentViewForTop(_ viewController: MJViewController) -> UIView {
        return profileView
    }
    
    func mjViewControllerTabViewForTop(_ viewController: MJViewController) -> UIView {
        return tabView
    }
    
    func mjViewController(_ viewController: MJViewController, didChangeSelectedIndex selectedIndex: Int) {
        tabView.selectedIndex = selectedIndex
    }
    
    func mjViewControllerNumberOfTabs(_ viewController: MJViewController) -> Int {
        return ProfileViewLayoutManager.TabTypes.count
    }
    
    func mjViewControllerTitlesForTab(_ viewController: MJViewController) -> [String] {
        return ProfileViewLayoutManager.TabTypes.map { $0.rawValue }
    }
    
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return layoutManager.cellForTargetIndex(targetIndex, indexPath: indexPath, tableView: tableView)
    }
    
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutManager.numberOfRowsInTargetIndex(targetIndex)
    }
}

extension ProfileViewController: MJViewControllerDelegate {
    func mjViewController(_ viewController: MJViewController, contentScrollViewDidScroll scrollView: UIScrollView) {
        tabView.syncOtherScrollView(scrollView)
    }
    
    func mjViewController(_ viewController: MJViewController, selectedIndex: Int, scrollViewDidScroll scrollView: UIScrollView) {
        let value = min(1, max(0, scrollView.contentOffset.y / headerHeight))
        profileView.backgroundImageView.blur(value)
        profileView.userIconImageView.alpha = 1 - value
        profileView.textView.alpha = 1 - value
        profileView.followButton.alpha = 1 - value
        navigationView?.titleLabel.alpha = value
    }
    
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return layoutManager.heightForTargetIndex(targetIndex)
    }
    
    func mjViewController(_ viewController: MJViewController, targetIndex: Int, tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("targetIndex = \(targetIndex) indexPath = \(indexPath)")
    }
}

extension ProfileViewController: ProfileTabViewDelegate {
    func profileTabView(_ view: ProfileTabView, didTapTab button: UIButton, index: Int) {
        selectedIndex = index
    }
}
