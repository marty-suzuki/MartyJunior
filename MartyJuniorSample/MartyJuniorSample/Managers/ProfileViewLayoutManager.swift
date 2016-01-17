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
        case Tweets = "Tweets"
        case Following = "Following"
        case Followers = "Followers"
    }
    
    //MARK: - Inner struct
    private struct User {
        let name: String
        let description: String
        let imageName: String
    }
    
    //MARK: - Static constants
    static let TabTypes: [TabType] = [.Tweets, .Following, .Followers]
    private static let TweetsCellContents: [String] = [
        "Great scott!\nhttps://github.com/szk-atmosphere/SAHistoryNavigationViewController",
        "This is heavey...\nhttps://github.com/szk-atmosphere/SAInboxViewController",
        "Back to the future!!\nhttps://github.com/szk-atmosphere/MisterFusion",
        "Nov 5th, 1955!\nhttps://github.com/szk-atmosphere/SABlurImageView",
        "Hey, McFly?\nhttps://github.com/szk-atmosphere/ReuseCellConfigure"
    ]
    
    private static let Users: [User] = [
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
    
    private static let FollowerCellContents: [User] = [Users[5], Users[6], Users[7], Users[8], Users[9]]
    private static let FollowingCellContents: [User] = Array([FollowerCellContents, Users].flatten())
    
    //MARK: Properties
    subscript(index: Int) -> TabType {
        return self.dynamicType.TabTypes[index]
    }
}

//MARK: - Configurations
extension ProfileViewLayoutManager {
    func cellForTargetIndex(index: Int, indexPath: NSIndexPath, tableView: UITableView) -> UITableViewCell {
        switch self[index] {
        case .Tweets:
            return tableView.dequeueReusableCellWithIdentifier(ProfileTweetCell.ReuseIdentifier, classForCell: ProfileTweetCell.self) {
                $0.textView.text = self.dynamicType.TweetsCellContents[indexPath.row]
            }!
        case .Following:
            return tableView.dequeueReusableCellWithIdentifier(ProfileUserCell.ReuseIdentifier, classForCell: ProfileUserCell.self) {
                let user = self.dynamicType.FollowingCellContents[indexPath.row]
                $0.userNameLabel.text = user.name
                $0.userDescriptionLabel.text = user.description
                $0.userIconImageView.image = UIImage(named: user.imageName)
            }!
        case .Followers:
            return tableView.dequeueReusableCellWithIdentifier(ProfileUserCell.ReuseIdentifier, classForCell: ProfileUserCell.self) {
                let user = self.dynamicType.FollowerCellContents[indexPath.row]
                $0.userNameLabel.text = user.name
                $0.userDescriptionLabel.text = user.description
                $0.userIconImageView.image = UIImage(named: user.imageName)
            }!
        }
    }
    
    func numberOfRowsInTargetIndex(index: Int) -> Int {
        switch self[index] {
            case .Tweets: return self.dynamicType.TweetsCellContents.count
            case .Following: return self.dynamicType.FollowingCellContents.count
            case .Followers: return self.dynamicType.FollowerCellContents.count
        }
    }
    
    func heightForTargetIndex(index: Int) -> CGFloat {
        switch self[index] {
            case .Tweets: return ProfileTweetCell.Height
            case .Following: return ProfileUserCell.Height
            case .Followers: return ProfileUserCell.Height
        }
    }
}