//
//  MJNavigationView.swift
//  Pods
//
//  Created by 鈴木大貴 on 2016/01/19.
//
//

import UIKit
import MisterFusion

public class MJNavigationView: UIView {
    static let Height: CGFloat = 44
    
    public let leftButton = UIButton(type: .Custom)
    public let rightButton = UIButton(type: .Custom)
    public let titleLabel = UILabel()
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addLayoutSubview(leftButton, andConstraints:
            leftButton.Top,
            leftButton.Left,
            leftButton.Bottom,
            leftButton.Width |=| self.dynamicType.Height
        )
        leftButton.hidden = true
        
        addLayoutSubview(rightButton, andConstraints:
            rightButton.Top,
            rightButton.Right,
            rightButton.Bottom,
            rightButton.Width |=| self.dynamicType.Height
        )
        rightButton.hidden = true
        
        addLayoutSubview(titleLabel, andConstraints:
            titleLabel.Top,
            titleLabel.Right |==| rightButton.Left,
            titleLabel.Bottom,
            titleLabel.Left |==| leftButton.Right
        )
        
        titleLabel.textAlignment = .Center
        titleLabel.font = .boldSystemFontOfSize(16)
        titleLabel.textColor = .whiteColor()
    }
}
