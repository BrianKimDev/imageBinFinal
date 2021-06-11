//
//  KeepSwipingButton.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//
import UIKit

class KeepSwipingButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let cornerRadius = rect.height / 2
        
        
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        
        // removing the middle of the button
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        
        maskLayer.path = maskPath
        maskLayer.fillRule = .evenOdd
        
        
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        gradientLayer.frame = rect
        
    }
}
