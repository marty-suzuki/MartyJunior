//
//  NSIndexPath+Previous.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/29.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit

extension NSIndexPath {
    func previousSection() -> NSIndexPath {
        if section < 1 { return self }
        return NSIndexPath(forRow: row, inSection: section - 1)
    }
}