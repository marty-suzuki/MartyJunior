//
//  ProfileTabView.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2016/01/19.
//  Copyright © 2016年 Taiki Suzuki. All rights reserved.
//

import UIKit

protocol ProfileTabViewDelegate: class {
    func profileTabView(view: ProfileTabView, didTapTab button: UIButton, index: Int)
}

class ProfileTabView: UIView {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    
    weak var delegate: ProfileTabViewDelegate?
    
    var selectedIndex: Int = 0 {
        didSet {
            buttons.enumerate().forEach {
                $0.element.selected = $0.index == selectedIndex
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.setContentOffset(CGPoint(x: (bounds.size.width / 3) * 2, y: 0), animated: false)
        
        buttons.forEach {
            $0.setTitleColor(self.indicatorView.backgroundColor, forState: .Selected)
            $0.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        buttons[0].selected = true
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        delegate?.profileTabView(self, didTapTab: sender, index: buttons.indexOf(sender) ?? 0)
    }
    
    func syncOtherScrollView(scrollView: UIScrollView) {
        let maxValue = (bounds.size.width / 3) * 2
        let point = CGPoint(x: max(0, min(maxValue - (scrollView.contentOffset.x / 3), maxValue)), y: 0)
        self.scrollView.setContentOffset(point, animated: false)
    }
}
