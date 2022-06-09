//
//  VideoInteractionController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/8.
//

import UIKit
import SwiftUI
import HandyJSON

class VideoInteractionController: UIViewController, UIGestureRecognizerDelegate {
    
    var playerVC: VideoMediaController?
    
    lazy var progressLabelView:FPPlayerProgressLabelView = {
        let view = FPPlayerProgressLabelView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 33))
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    lazy var playOrPauseBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 56, height: 56))
        btn.setImage(UIImage(named: "player_play"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    lazy var sliderView:FPVideoPlayerSliderView = {
        let sliderView = FPVideoPlayerSliderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        sliderView.contentMode = .bottom
        sliderView.allowTapped = false
        sliderView.maximumTrackTintColor = UIColor.clear
        sliderView.delegate = self
        sliderView.minimumTrackTintColor = UIColor.init(white: 1, alpha: 0.2)
        
        sliderView.backgroundColor = UIColor.clear
        sliderView.sliderRadius = 2
        sliderView.sliderHeight = 2
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_normal") ?? UIImage(),for: .normal)
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_selected") ?? UIImage(), for: .selected)
        //        sliderView.
        //        sliderView.expandResponseAreaBounds(UIEdgeInsets(top: 12, left: 0, bottom: 5, right: 0))
        return sliderView
    }()
    
    private lazy var singleTapGesture:UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(_:)))
        singleTap.delegate = self
        singleTap.delaysTouchesBegan = true
        singleTap.delaysTouchesEnded = true
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1
        return singleTap
    }()
    
    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.delegate = self;
        doubleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesEnded = true
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    } ()
    
    
    
    
    
    private func setupUIAndGestures() {
        view.addGestureRecognizer(singleTapGesture)
        view.addGestureRecognizer(doubleTapGesture)
        view.backgroundColor = .clear
        
        view.addSubview(playOrPauseBtn)
        view.addSubview(sliderView)
        view.addSubview(progressLabelView)
    }
    
    
    @objc private func handleSingleTap(_ gesture: UITapGestureRecognizer) {
        
        guard playerVC?.isPlayerPlaying() == true else {
            // 非正在播放
            if (playerVC?.isPlayerPaused() == true) {
                playerVC?.playVideo()
                changeSliderUIToOrigin()
                playOrPauseBtn.isHidden = true
            }
            return
        }
        playerVC?.pauseVideo()
        changeSliderUIToBold()
        playOrPauseBtn.isHidden = false
    }
    
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        
    }
    
    
}


// MARK: - lifecycle
extension VideoInteractionController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIAndGestures()
        
        
        playerVC?.playerPlayTimeChanged = {[weak self]  (currentTime:TimeInterval,duration:TimeInterval) -> Void in
            self?.sliderView.isHidden = false
            
            if  self?.sliderView.isdragging == false {
                self?.sliderView.value = duration <= 0 ? 0 : Float(currentTime / duration)
            }
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playOrPauseBtn.center = CGPoint.init(x: view.qy_width * 0.5, y: view.qy_height * 0.5)
        progressLabelView.qy_bottom = view.qy_height - 51
        
        sliderView.qy_bottom = view.qy_bottom
        
    }
}


// MARK: - 进度条滑块
extension VideoInteractionController: FPVideoPlayerSliderViewDelegate {
    
    func changeSliderUIToBold() {
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_selected")!, for: .normal)
        sliderView.sliderHeight = 4
        sliderView.qy_bottom = view.qy_height
        sliderView.minimumTrackTintColor = .white
    }
    
    func changeSliderUIToOrigin () {
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_normal")!, for: .normal)
        sliderView.sliderHeight = 2
        sliderView.minimumTrackTintColor = UIColor.init(white: 1, alpha: 0.2)
        sliderView.qy_bottom = view.qy_height
    }
    
    // 滑块滑动开始
    func sliderTouchBegan(_ value: Float) {
        sliderView.isdragging = true
        changeSliderUIToBold()
    }
    
    // 滑块滑动中
    func sliderValueChanged(_ value: Float) {
        
        guard let videoTotalTime = self.playerVC?.videoTotalTime() else {
            sliderView.value = 0
            return
        }
        sliderView.isdragging = true
        sliderView.value = value
        
        //        bottomContentView.hidden = true
        progressLabelView.isHidden = false
        
        
        progressLabelView.currentTimeStr = "11"
        progressLabelView.totalTimeStr  = String.init(format: "%d", videoTotalTime)
    }
    
    // 滑块滑动结束
    func sliderTouchEnded(_ value: Float) {
        progressLabelView.isHidden = true
        //        bottomContentView.hidden = false
        changeSliderUIToOrigin()
        
        // FIXME: xxxx
        let videoTotalTime = self.playerVC?.videoTotalTime()
        
        guard videoTotalTime != nil && videoTotalTime! > 0 else {
            sliderView.isdragging = false
            sliderView.value = 0
            return
        }
        
        
        playerVC?.playerSeek(toTime:Double(value) * videoTotalTime!, completionHandler: {[weak self] (isFinished: Bool) -> Void in
            if isFinished {
                self?.sliderView.isdragging = false
            }
        })
        
        
        
    }
}
