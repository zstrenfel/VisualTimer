//
//  VisualTimer.swift
//  VisualTimer
//
//  Created by Zach Strenfel on 3/20/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit
import QuartzCore

class VisualTimer: UIView {
    
    override var frame: CGRect {
        didSet{
            updateLayerFrames()
        }
    }
    
    weak var delegate: VisualTimerDelegate? = nil
    var currLocation: CGPoint = CGPoint()
    
    //Time Variables
    var time: Double = 10.0
    var currTime: Double = 5.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var paused: Bool = true
    var interval: Double = 0.0
    var countdown: Double = 0.0
    var cooldown: Double = 0.0
    var primary: Double = 0.0
    
    //Visual Design Variables
    var inset: Double = 8.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    var indicatorRadius: Double = 20.0
    
    let startPoint: Double = 0.0
    let endPoint: Double = 360.0
    
    //CoreGraphics Layers
    let trackLayer = VisualTimerTrackLayer()
    var indicatorLayers: [VisualTimerIndicatorLayer] = []
    var indicatorLayerRadius: CGFloat = 10.0
    var intervalLayerWidth: CGFloat = 10.0
    
    init(frame: CGRect, timer: ExampleTimer) {
        super.init(frame: frame)
        
        trackLayer.visualTimer = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        self.countdown = timer.countdown
        self.primary = timer.primary
        self.cooldown = timer.cooldown
        self.interval = timer.interval
        
        if countdown != 0.0 {
            indicatorLayers.append(VisualTimerIndicatorLayer())
        }
        
        if cooldown != 0.0 {
            indicatorLayers.append(VisualTimerIndicatorLayer())
        }
        
        
        if interval > 0.0 {
            let intervalCount = floor(primary / interval)
            for _ in 0...Int(intervalCount) {
                indicatorLayers.append(VisualTimerIndicatorLayer())
            }
        }
        
        for indicator in indicatorLayers {
            indicator.visualTimer = self
            indicator.contentsScale = UIScreen.main.scale
            layer.addSublayer(indicator)
        }
        
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        
        trackLayer.frame = bounds.insetBy(dx: CGFloat(inset), dy: CGFloat(inset))
        trackLayer.setNeedsDisplay()
        
        var currIndex = 0
        
        if countdown != 0.0 {
            let indicatorLayer = indicatorLayers[currIndex]
            let position: CGPoint = positionForValue(value: countdown)
            indicatorLayer.frame = CGRect(x: position.x, y: position.y, width: CGFloat(indicatorRadius), height: CGFloat(indicatorRadius))
            currIndex += 1
            indicatorLayer.setNeedsDisplay()
        }
        
        if cooldown != 0.0 {
            let indicatorLayer = indicatorLayers[currIndex]
            let position: CGPoint = positionForValue(value: countdown)
            indicatorLayer.frame = CGRect(x: position.x, y: position.y, width: CGFloat(indicatorRadius), height: CGFloat(indicatorRadius))
            currIndex += 1
            indicatorLayer.setNeedsDisplay()
        }
        
        if interval > 0.0 {
            let intervalCount = Int(floor(primary / interval))
            var currInterval = 1.0
            for _ in currIndex...intervalCount {
                let indicatorLayer = indicatorLayers[currIndex]
                let position: CGPoint = positionForValue(value: interval * currInterval)
                indicatorLayer.frame = CGRect(x: position.x, y: position.y, width: CGFloat(indicatorRadius), height: CGFloat(indicatorRadius))
                currInterval += 1
                currIndex += 1
                indicatorLayer.setNeedsDisplay()
            }
        }
        
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> CGPoint {
        let r = valueToRadians(value)
        let radius = Double(trackLayer.bounds.width/2)
        let xCord = radius * cos(r) + Double(bounds.size.width/2)
        let yCord = radius * sin(r) + Double(bounds.size.width/2)
        return CGPoint(x: xCord, y: yCord)
    }
    
    //Converts a value to it's corresponding radian value as compared to total time
    func valueToRadians(_ value: Double) -> Double {
        return (2 * M_PI) * (value / time)
    }

}
