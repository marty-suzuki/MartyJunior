//
//  MJTabContainerView.swift
//  Pods
//
//  Created by 鈴木大貴 on 2015/11/26.
//
//

import UIKit
import MisterFusion

protocol MJContentViewDelegate: class {
    func contentView(contentView: MJContentView, didChangeValueOfSegmentedControl segmentedControl: UISegmentedControl)
}

class MJContentView: UIView {

    static let Height: CGFloat = 300
    
    let tabContainerView: UIView = UIView()
    let segmentedControl = UISegmentedControl()
    
    weak var delegate: MJContentViewDelegate?
    
    init() {
        super.init(frame: .zero)
        initalize()
    }
    
    private func initalize() {
        for index in 0..<3 {
            segmentedControl.insertSegmentWithTitle("\(index)", atIndex: index, animated: false)
        }
        segmentedControl.addTarget(self, action: "didChangeValueOfSegmentedControl:", forControlEvents: .ValueChanged)
        
        tabContainerView.addLayoutSubview(segmentedControl, andConstraints:
            segmentedControl.Left |+| 8,
            segmentedControl.Right |-| 8,
            segmentedControl.Bottom |-| 8,
            segmentedControl.Top,
            segmentedControl.Height |=| 34
        )
        
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
