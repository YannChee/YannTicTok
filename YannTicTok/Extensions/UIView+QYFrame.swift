//
//  UIView+QYFrame.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/27.
//

import UIKit

// MARK: - Properties
extension UIView {
    
    /// x origin of view.
    var qy_x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// y origin of view.
    var qy_y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    /// Width of view.
    var qy_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    /// Height of view.
    var qy_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// Size of view.
    var qy_size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    /// Origin of view.
    var qy_origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }

    /// CenterX of view.
    var qy_centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }

    /// CenterY of view.
    var qy_centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }

    /// Bottom of view.
    var qy_bottom: CGFloat {
        set {
            frame.origin.y = newValue - frame.size.height
        }
        
        get {
            return frame.maxY
        }
    }

}
