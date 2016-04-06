//
//  MJTabContainerView.swift
//  MartyJunior
//
//  Created by 鈴木大貴 on 2015/11/26.
//  Copyright © 2015年 Taiki Suzuki. All rights reserved.
//

import UIKit
import MisterFusion

protocol MJContentViewDelegate: class {
    func contentView(contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl)
}

class MJContentView: UIView {
    var height: CGFloat {
        guard let userDefinedView = userDefinedView else { return 50 }
        return CGRectGetHeight(userDefinedView.frame) + 50
    }
    
    var userDefinedView: UIView? {
        didSet {
            guard let userDefinedView = userDefinedView else { return }
            addLayoutSubview(userDefinedView, andConstraints:
                userDefinedView.Top,
                userDefinedView.Left,
                userDefinedView.Right,
                userDefinedView.Height |==| CGRectGetHeight(userDefinedView.frame)
            )
            sendSubviewToBack(userDefinedView)
        }
    }
    
    var userDefinedTabView: UIView?
    
    let tabContainerView: UIView = UIView()
    let segmentedControl: UISegmentedControl = UISegmentedControl()
    
    var titles: [String]? {
        didSet {
            guard let titles = titles else { return }
            segmentedControl.removeAllSegments()
            titles.enumerate().forEach { segmentedControl.insertSegmentWithTitle($1, atIndex: $0, animated: false) }
        }
    }
    
    weak var delegate: MJContentViewDelegate?
    
    init() {
        super.init(frame: .zero)
    }
    
    func setupTabView() {
        if let userDefinedTabView = userDefinedTabView {
            tabContainerView.addLayoutSubview(userDefinedTabView, andConstraints:
                userDefinedTabView.Top,
                userDefinedTabView.Left,
                userDefinedTabView.Right,
                userDefinedTabView.Bottom,
                userDefinedTabView.Height |==| CGRectGetHeight(userDefinedTabView.frame)
            )
        } else {
            segmentedControl.addTarget(self, action: #selector(self.dynamicType.didChangeValueOfSegmentedControl(_:)), forControlEvents: .ValueChanged)
            
            tabContainerView.addLayoutSubview(segmentedControl, andConstraints:
                segmentedControl.Left |+| 8,
                segmentedControl.Right |-| 8,
                segmentedControl.Bottom |-| 8,
                segmentedControl.Top |+| 8,
                segmentedControl.Height |==| 34
            )
            
            tabContainerView.backgroundColor = .whiteColor()
        }
        
        addLayoutSubview(tabContainerView, andConstraints:
            tabContainerView.Left,
            tabContainerView.Right,
            tabContainerView.Bottom
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeValueOfSegmentedControl(segmentedControl: UISegmentedControl) {
        delegate?.contentView(self, didChangeValueOfSegmentedControl: segmentedControl)
    }
}
