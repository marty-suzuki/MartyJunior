//
//  MJTableViewTopCell.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MisterFusion

class MJTableViewTopCell: UITableViewCell {

    static let ReuseIdentifier: String = "MJTableViewTopCell"
    
    weak var mainContentView: MJContentView? {
        didSet {
            guard let mainContentView = mainContentView else { return }
            contentView.addLayoutSubview(mainContentView, andConstraints:
                mainContentView.Top,
                mainContentView.Left,
                mainContentView.Right,
                mainContentView.Height |==| mainContentView.height
            )
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        selectionStyle = .None
    }
}
