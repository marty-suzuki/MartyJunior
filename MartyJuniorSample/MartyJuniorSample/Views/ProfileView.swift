//
//  ProfileView.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2015/12/03.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

extension NSObject {
    static var className: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
    }
}

extension UIView {
    static var Nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
}

class ProfileView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
