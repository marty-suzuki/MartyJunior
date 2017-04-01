//
//  ProfileView.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2015/12/03.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import SABlurImageView

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension UIView {
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
}

class ProfileView: UIView {
    @IBOutlet weak var backgroundImageView: SABlurImageView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.configrationForBlurAnimation(20)
    }
}
