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
//    weak var delegate: VisualTimerDelegate? = nil
    var currLocation: CGPoint = CGPoint()
    
    //Time Variables
    var time: Double = 20.0
    var paused: Bool = true
    var interval: Double? = nil
    var countdown: Double = 0.0
    var cooldown: Double = 0.0
    
    //Visual Design Variables
    var inset: CGFloat = 8.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    
    //CoreGraphics Layers
    let trackLayer = CAShapeLayer()
    let indicatorLayer = CALayer()
    var indicatorLayerRadius: CGFloat = 10.0
    let intervalLayers: [CALayer] = []
    var intervalLayerWidth: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.backgroundColor = trackColor
        layer.addSublayer(trackLayer)
        
        indicatorLayer.backgroundColor = indicatorColor
        layer.addSublayer(indicatorLayer)
        
        for _ in intervalLayers {
            //crete interval layers here
        }
        
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        drawTrack()
    }
    
    func drawTrack() {
        let halfSize: CGFloat = min(bounds.size.width/2 - inset, bounds.size.height/2 -  inset)
        let circleTrack = UIBezierPath(
            arcCenter: CGPoint(x: bounds.size.width/2, y: bounds.size.height/2),
            radius: CGFloat(halfSize - CGFloat(trackWidth / 2)),
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        
        trackLayer.path = circleTrack.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor
        trackLayer.lineWidth = CGFloat(trackWidth)
        trackLayer.strokeEnd = 0.0
        
        trackLayer.setNeedsDisplay()
    }
    
    func animateCircle() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 100.00
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: "linear")
        
        trackLayer.strokeEnd = 1.0
        trackLayer.add(animation, forKey: "animateCircle")
    }
    
    func positionForValue(value: Double) {
        
    }
    

}
