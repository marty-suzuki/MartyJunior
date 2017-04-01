//
//  ProfileTweetCell.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2016/01/17.
//  Copyright © 2016年 Taiki Suzuki. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var ReuseIdentifier: String {
        return className
    }
}

class ProfileTweetCell: UITableViewCell {
    static var defaultHeight: CGFloat = 88
    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.textContainerInset = .zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
