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
            leftButtonContainerView.top,
            leftButtonContainerView.left,
            leftButtonContainerView.bottom,
            leftButtonContainerView.width |==| self.dynamicType.Height
        )
        leftButtonContainerView.backgroundColor = .clear()
        
        addLayoutSubview(rightButtonContainerView, andConstraints:
            rightButtonContainerView.top,
            rightButtonContainerView.right,
            rightButtonContainerView.bottom,
            rightButtonContainerView.width |==| self.dynamicType.Height
        )
        rightButtonContainerView.backgroundColor = .clear()
        
        addLayoutSubview(titleLabel, andConstraints:
            titleLabel.top,
            titleLabel.right |==| rightButtonContainerView.left,
            titleLabel.bottom,
            titleLabel.left |==| leftButtonContainerView.right
        )
        
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white()
    }
    
    private func addButton(_ button: UIButton?, toContainerView containerView: UIView) {
        guard let button = button else { return }
        containerView.addLayoutSubview(button, andConstraints:
            button.top,
            button.right,
            button.left,
            button.bottom
        )
    }
}
