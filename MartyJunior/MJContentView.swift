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
    func contentView(_ contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl)
}

class MJContentView: UIView {
    var currentHeight: CGFloat {
        guard let userDefinedView = userDefinedView else { return 50 }
        return userDefinedView.frame.height + 50
    }
    
    var userDefinedView: UIView? {
        didSet {
            guard let userDefinedView = userDefinedView else { return }
            addLayoutSubview(userDefinedView, andConstraints:
                userDefinedView.top,
                userDefinedView.left,
                userDefinedView.right,
                userDefinedView.height |==| userDefinedView.frame.height
            )
            sendSubview(toBack: userDefinedView)
        }
    }
    
    var userDefinedTabView: UIView?
    
    let tabContainerView: UIView = UIView()
    let segmentedControl: UISegmentedControl = UISegmentedControl()
    
    var titles: [String]? {
        didSet {
            guard let titles = titles else { return }
            segmentedControl.removeAllSegments()
            titles.enumerated().forEach { segmentedControl.insertSegment(withTitle: $1, at: $0, animated: false) }
        }
    }
    
    weak var delegate: MJContentViewDelegate?
    
    init() {
        super.init(frame: .zero)
    }
    
    func setupTabView() {
        if let userDefinedTabView = userDefinedTabView {
            tabContainerView.addLayoutSubview(userDefinedTabView, andConstraints:
                userDefinedTabView.top,
                userDefinedTabView.left,
                userDefinedTabView.right,
                userDefinedTabView.bottom,
                userDefinedTabView.height |==| userDefinedTabView.frame.height
            )
        } else {
            segmentedControl.addTarget(self, action: #selector(self.dynamicType.didChangeValueOfSegmentedControl(_:)), for: .valueChanged)
            
            tabContainerView.addLayoutSubview(segmentedControl, andConstraints:
                segmentedControl.left |+| 8,
                segmentedControl.right |-| 8,
                segmentedControl.bottom |-| 8,
                segmentedControl.top |+| 8,
                segmentedControl.height |==| 34
            )
            
            tabContainerView.backgroundColor = .white()
        }
        
        addLayoutSubview(tabContainerView, andConstraints:
            tabContainerView.left,
            tabContainerView.right,
            tabContainerView.bottom
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didChangeValueOfSegmentedControl(_ segmentedControl: UISegmentedControl) {
        delegate?.contentView(self, didChangeValueOfSegmentedControl: segmentedControl)
    }
}
