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
    var currTime: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var paused: Bool = true
    var interval: Double? = nil
    var countdown: Double = 0.0
    var cooldown: Double = 0.0
    
    //Visual Design Variables
    var inset: Double = 8.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    var radius: Double = 0.0
    var indicatorRadius: Double = 5.0
    
    let startPoint: Double = 0.0
    let endPoint: Double = 360.0
    
    //CoreGraphics Layers
    let trackLayer = VisualTimerTrackLayer()
    let indicatorLayer = CAShapeLayer()
    var indicatorLayerRadius: CGFloat = 10.0
    let intervalLayers: [CALayer] = []
    var intervalLayerWidth: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.visualTimer = self
        trackLayer.contentsScale = UIScreen.main.scale
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
        drawIndicator(value: currTime)
    }
    
    func drawTrack() {
        let halfSize: CGFloat = min(bounds.size.width/2 - CGFloat(inset), bounds.size.height/2 -  CGFloat(inset))
        radius = Double(halfSize - CGFloat(trackWidth / 2))
        let circleTrack = UIBezierPath(
            arcCenter: CGPoint(x: bounds.size.width/2, y: bounds.size.height/2),
            radius: CGFloat(radius),
            startAngle: CGFloat(valueToRadians(startPoint)),
            endAngle: CGFloat(valueToRadians(currTime)),
            clockwise: true)
        
        trackLayer.path = circleTrack.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor
        trackLayer.lineWidth = CGFloat(trackWidth)
        trackLayer.lineCap = kCALineCapRound
        
        trackLayer.setNeedsDisplay()
    }
    
    func drawIndicator(value: Double) {
        let indicatorCord = positionForValue(value: value)
        let indicatorTrack = UIBezierPath(
            arcCenter: indicatorCord,
            radius: CGFloat(indicatorRadius),
            startAngle: CGFloat(0),
            endAngle: CGFloat(2 * M_PI),
            clockwise: true)
        
        indicatorLayer.path = indicatorTrack.cgPath
        indicatorLayer.fillColor = UIColor.blue.cgColor
        indicatorLayer.strokeColor = UIColor.blue.cgColor
        
        indicatorLayer.setNeedsDisplay()
    }
    
    func positionForValue(value: Double) -> CGPoint {
        let r = valueToRadians(value)
        let xCord = radius * cos(r) + Double(bounds.size.width/2)
        let yCord = radius * sin(r) + Double(bounds.size.width/2)
        return CGPoint(x: xCord, y: yCord)
    }
    
    //Converts a value to it's corresponding radian value as compared to total time
    func valueToRadians(_ value: Double) -> Double {
        return (2 * M_PI) * (value / time)
    }

}
