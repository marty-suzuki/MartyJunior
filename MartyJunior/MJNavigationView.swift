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
    
    public let titleLabel = UILabel()
    public var leftButton: UIButton? {
        didSet {
            addButton(leftButton, toContainerView: leftButtonContainerView)
        }
    }
    public var rightButton: UIButton? {
        didSet {
            addButton(rightButton, toContainerView: rightButtonContainerView)
        }
    }
    
    private let leftButtonContainerView = UIView()
    private let rightButtonContainerView = UIView()
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addLayoutSubview(leftButtonContainerView, andConstraints:
            leftButtonContainerView.Top,
            leftButtonContainerView.Left,
            leftButtonContainerView.Bottom,
            leftButtonContainerView.Width |==| self.dynamicType.Height
        )
        leftButtonContainerView.backgroundColor = .clearColor()
        
        addLayoutSubview(rightButtonContainerView, andConstraints:
            rightButtonContainerView.Top,
            rightButtonContainerView.Right,
            rightButtonContainerView.Bottom,
            rightButtonContainerView.Width |==| self.dynamicType.Height
        )
        rightButtonContainerView.backgroundColor = .clearColor()
        
        addLayoutSubview(titleLabel, andConstraints:
            titleLabel.Top,
            titleLabel.Right |==| rightButtonContainerView.Left,
            titleLabel.Bottom,
            titleLabel.Left |==| leftButtonContainerView.Right
        )
        
        titleLabel.textAlignment = .Center
        titleLabel.font = .boldSystemFontOfSize(16)
        titleLabel.textColor = .whiteColor()
    }
    
    private func addButton(button: UIButton?, toContainerView containerView: UIView) {
        guard let button = button else { return }
        containerView.addLayoutSubview(button, andConstraints:
            button.Top,
            button.Right,
            button.Left,
            button.Bottom
        )
    }
}
