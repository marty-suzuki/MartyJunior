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

class ProfileViewLayoutManager {
    enum TabType: String {
        case Tweets = "Tweets"
        case Following = "Following"
        case Followers = "Followers"
    }
    
    static let TabTypes: [TabType] = [.Tweets, .Following, .Followers]
    
    subscript(index: Int) -> TabType {
        return self.dynamicType.TabTypes[index]
    }
}

class ProfileViewController: MJViewController {
    //MARK: - Properties
    private let layoutManager = ProfileViewLayoutManager()
    private let profileView = ProfileView.Nib.instantiateWithOwner(nil, options: nil).first as! UIView
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        dataSource = self
        
        registerNibToAllTableViews(ProfileTweetCell.Nib, forCellReuseIdentifier: ProfileTweetCell.ReuseIdentifier)
        registerNibToAllTableViews(ProfileUserCell.Nib, forCellReuseIdentifier: ProfileUserCell.ReuseIdentifier)
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
    
    func mjViewControllerTitlesForTab(viewController: MJViewController) -> [String] {
        return ProfileViewLayoutManager.TabTypes.map { $0.rawValue }
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch layoutManager[targetIndex] {
            case .Tweets:
                return tableView.dequeueReusableCellWithIdentifier(ProfileTweetCell.ReuseIdentifier, classForCell: ProfileTweetCell.self) {
                    $0.contentView.backgroundColor = indexPath.row % 2 == 0 ? .redColor() : .brownColor()
                }!
            case .Following:
                return tableView.dequeueReusableCellWithIdentifier(ProfileUserCell.ReuseIdentifier, classForCell: ProfileUserCell.self) {
                    $0.contentView.backgroundColor = indexPath.row % 2 == 0 ? .greenColor() : .whiteColor()
                }!
            case .Followers:
                return tableView.dequeueReusableCellWithIdentifier(ProfileUserCell.ReuseIdentifier, classForCell: ProfileUserCell.self) {
                    $0.contentView.backgroundColor = indexPath.row % 2 == 0 ? .yellowColor() : .blackColor()
                }!
        }
    }
    
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch layoutManager[targetIndex] {
            case .Tweets: return 5
            case .Following: return 20
            case .Followers: return 5
        }
    }
}

extension ProfileViewController: MJViewControllerDelegate {
    func mjViewController(viewController: MJViewController, targetIndex: Int, tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch layoutManager[targetIndex] {
            case .Tweets: return ProfileTweetCell.Height
            case .Following: return ProfileUserCell.Height
            case .Followers: return ProfileUserCell.Height
        }
    }
}