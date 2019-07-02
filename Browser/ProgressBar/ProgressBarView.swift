//
//  ProgressBarView.swift
//  Browser
//
//  Created by Dam Thieu Quang on 6/10/19.
//  Copyright © 2019 Dam Thieu Quang. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    var progress : CGFloat = 0.0
    var progressLine : UIView?
    var constraintsWidthProgressLine : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProgressLine() {
        self.progressLine = UIView()
        self.progressLine?.backgroundColor = .yellow
        self.progressLine?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.progressLine!)
        self.progressLine?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.progressLine?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.progressLine?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.constraintsWidthProgressLine = self.progressLine?.widthAnchor.constraint(equalToConstant: 0)
        self.constraintsWidthProgressLine?.isActive = true
        print("\(String(describing: self.constraintsWidthProgressLine?.constant))")
        
    }
    
    func setProgress(ratio : CGFloat) {
//        print("calculate:\(ratio * self.frame.size.width)")
        self.constraintsWidthProgressLine?.constant = ratio * self.frame.size.width
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.layoutIfNeeded()
        }
        
    }
    
    
}
