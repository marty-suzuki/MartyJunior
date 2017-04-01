//
//  ProfileViewLayoutManager.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2016/01/18.
//  Copyright © 2016年 Taiki Suzuki. All rights reserved.
//

import UIKit

class ProfileViewLayoutManager {
    //MARK: - Inner enum
    enum TabType: String {
        case tweets = "Tweets"
        case following = "Following"
        case followers = "Followers"
    }
    
    //MARK: - Inner struct
    private struct User {
        let name: String
        let description: String
        let imageName: String
    }
    
    //MARK: - Static constants
    static let tabTypes: [TabType] = [.tweets, .following, .followers]
    
    private struct Const {
        static let tweetsCellContents: [String] = [
            "Great scott!\nhttps://github.com/marty-suzuki/SAHistoryNavigationViewController",
            "This is heavey...\nhttps://github.com/marty-suzuki/SAInboxViewController",
            "Back to the future!!\nhttps://github.com/marty-suzuki/MisterFusion",
            "Nov 5th, 1955!\nhttps://github.com/marty-suzuki/SABlurImageView",
            "Hey, McFly?\nhttps://github.com/marty-suzuki/ReuseCellConfigure"
        ]
    
        static let users: [User] = [
            User(name: "Marty McFly", description: "Future boy comes from 1985.", imageName: "martymc"),
            User(name: "Doc. Emmett Brown", description: "The local scientist invented time machine.", imageName: "doc"),
            User(name: "Biff Tannen", description: "A enemy of Marty in 1955 and 1985.", imageName: "biff"),
            User(name: "George McFly", description: "Marty's farther.", imageName: "geo"),
            User(name: "Lorraine Baines McFly", description: "Marty's mother.", imageName: "lor"),
            User(name: "Marty McFly, Junior", description: "Marty's son.", imageName: "junior"),
            User(name: "Buford Tannen", description: "A enemy of Marty in 1885", imageName: "maddog"),
            User(name: "Mr. Strickland", description: "A teacher", imageName: "strickland"),
            User(name: "Douglas Needles", description: "Marty's friend.", imageName: "needles"),
            User(name: "Einstein", description: "Doc's dog in 1985.", imageName: "einstein")
        ]
    
        static let followerCellContents: [User] = [users[5], users[6], users[7], users[8], users[9]]
        static let followingCellContents: [User] = Array([followerCellContents, users].joined())
    }
    
    //MARK: Properties
    subscript(index: Int) -> TabType {
        return ProfileViewLayoutManager.tabTypes[index]
    }

    //MARK: - Configurations
    func cellForTargetIndex(_ index: Int, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch self[index] {
        case .tweets:
            return tableView.dequeueReusableCell(withIdentifier: ProfileTweetCell.ReuseIdentifier) { (cell: ProfileTweetCell) in
                cell.textView.text = Const.tweetsCellContents[indexPath.row]
            }!
        case .following:
            return tableView.dequeueReusableCell(withIdentifier: ProfileUserCell.ReuseIdentifier) { (cell: ProfileUserCell) in
                let user = Const.followingCellContents[indexPath.row]
                cell.userNameLabel.text = user.name
                cell.userDescriptionLabel.text = user.description
                cell.userIconImageView.image = UIImage(named: user.imageName)
            }!
        case .followers:
            return tableView.dequeueReusableCell(withIdentifier: ProfileUserCell.ReuseIdentifier) { (cell: ProfileUserCell) in
                let user = Const.followerCellContents[indexPath.row]
                cell.userNameLabel.text = user.name
                cell.userDescriptionLabel.text = user.description
                cell.userIconImageView.image = UIImage(named: user.imageName)
            }!
        }
    }
    
    func numberOfRowsInTargetIndex(_ index: Int) -> Int {
        switch self[index] {
            case .tweets: return Const.tweetsCellContents.count
            case .following: return Const.followingCellContents.count
            case .followers: return Const.followerCellContents.count
        }
    }
    
    func heightForTargetIndex(_ index: Int) -> CGFloat {
        switch self[index] {
            case .tweets: return ProfileTweetCell.defaultHeight
            case .following: return ProfileUserCell.defaultHeight
            case .followers: return ProfileUserCell.defaultHeight
        }
    }
}
