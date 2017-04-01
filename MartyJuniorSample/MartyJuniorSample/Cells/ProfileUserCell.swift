//
//  ProfileUserCell.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2016/01/17.
//  Copyright © 2016年 Taiki Suzuki. All rights reserved.
//

import UIKit

class ProfileUserCell: UITableViewCell {

    static var defaultHeight: CGFloat = 56
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
