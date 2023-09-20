//
//  SegmentedBarView.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 23/03/22.
//

import UIKit

class SegmentedBarView: UIStackView{
    
    
    init(numberOfSegments: Int){
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = UIColor.barDeselectedColor
            addArrangedSubview(barView)
        }
        arrangedSubviews.first?.backgroundColor = .white
        spacing = 4
        distribution = .fillEqually
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int){
        arrangedSubviews.forEach({$0.backgroundColor = .barDeselectedColor})
        arrangedSubviews[index].backgroundColor = .white
    }
    
    
}
