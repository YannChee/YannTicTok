//
//  UIView+QYFrame.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/27.
//

import UIKit

// MARK: - Properties
extension UIView {
    
    var qy_left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var qy_top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    var qy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var qy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var qy_size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var qy_origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }

    var qy_centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }

    var qy_centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }

    var qy_bottom: CGFloat {
        set {
            frame.origin.y = newValue - frame.size.height
        }
        
        get {
            return frame.maxY
        }
    }

    var qy_right: CGFloat {
        set {
            frame.origin.x = newValue - frame.size.width;
        }
        
        get {
            return frame.origin.x + frame.size.width
        }
    }
}
