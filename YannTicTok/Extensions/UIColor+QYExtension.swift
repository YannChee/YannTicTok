//
//  UIColor+QYExtension.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/27.
//

import UIKit

extension UIColor {
    
    /// 返回一个随机得出来的RGB颜色, 透明度为1.0
  public class var random: UIColor {
        let red = CGFloat(Int.random(in: 0...255))
        let green = CGFloat(Int.random(in: 0...255))
        let blue = CGFloat(Int.random(in: 0...255))
        return UIColor.init(red, green, blue)
    }
    
    
    
    
    public convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue:b/255.0, alpha:a)
    }
}
