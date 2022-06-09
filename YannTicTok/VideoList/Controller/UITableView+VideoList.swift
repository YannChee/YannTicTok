//
//  UITableView+VideoList.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/27.
//

import UIKit

extension UITableView {
    
    public func findMinCenterCell() -> UITableViewCell? {
        guard self.isHidden == false  else {
            return nil
        }
        
        guard visibleCells.count != 0 else {
            return nil
        }
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        var minDeltaCell: UITableViewCell? = nil;
        var minDelta = UIScreen.main.bounds.height * 0.5
        
        for cell in visibleCells {
            // 转换坐标系
            let cellCenterInTargetView: CGPoint =  cell.superview!.convert(cell.center, to: keyWindow)
            let tempDelta = abs(cellCenterInTargetView.y - keyWindow!.center.y)
           
            if tempDelta < minDelta {
                minDelta = tempDelta
                minDeltaCell = cell
            }
        }
        return minDeltaCell
    }
    
    
    private func currentIndexPath() -> IndexPath {
        let point = CGPoint.init(x: 100, y: contentOffset.y + frame.size.height * 0.5)
        return indexPathForRow(at: point) ?? IndexPath.init(row: 0, section: 0)
    }

}


