//
//  SegmentedBarView.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        // create as many bars as user has photos, use imageURLs array to figure out how many bars
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            addArrangedSubview(barView)
            
        }
        
        spacing = 5
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .white
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach({ $0.backgroundColor = .barDeselectedColor })
        arrangedSubviews[index].backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        
    }
}


