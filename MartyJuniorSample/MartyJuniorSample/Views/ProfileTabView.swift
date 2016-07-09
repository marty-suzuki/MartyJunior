//
//  ProfileTabView.swift
//  MartyJuniorSample
//
//  Created by 鈴木大貴 on 2016/01/19.
//  Copyright © 2016年 Taiki Suzuki. All rights reserved.
//

import UIKit

protocol ProfileTabViewDelegate: class {
    func profileTabView(_ view: ProfileTabView, didTapTab button: UIButton, index: Int)
}

class ProfileTabView: UIView {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    
    weak var delegate: ProfileTabViewDelegate?
    
    var selectedIndex: Int = 0 {
        didSet {
            buttons.enumerated().forEach {
                $0.element.isSelected = $0.offset == selectedIndex
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: (bounds.size.width / 3) * 2, y: 0), animated: false)
        
        buttons.forEach {
            $0.setTitleColor(self.indicatorView.backgroundColor, for: .selected)
            $0.setTitleColor(UIColor.lightGray(), for: UIControlState())
        }
        buttons[0].isSelected = true
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.profileTabView(self, didTapTab: sender, index: buttons.index(of: sender) ?? 0)
    }
    
    func syncOtherScrollView(_ scrollView: UIScrollView) {
        let maxValue = (bounds.size.width / 3) * 2
        let point = CGPoint(x: max(0, min(maxValue - (scrollView.contentOffset.x / 3), maxValue)), y: 0)
        self.scrollView.setContentOffset(point, animated: false)
    }
}
