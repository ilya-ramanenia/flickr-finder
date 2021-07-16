//
//  UIView+Inspectable.swift
//  FlickrFinder
//
//  Created by ilya Ramanenia on 25.07.21.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            layer.shadowColor.map(UIColor.init(cgColor:))
        }
        set {
            layer.shadowColor = newValue.map(\.cgColor)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowRadius: Float {
        get {
            Float(layer.shadowRadius)
        }
        set {
            layer.shadowRadius = CGFloat(newValue)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            setNeedsDisplay()
        }
    }
}
