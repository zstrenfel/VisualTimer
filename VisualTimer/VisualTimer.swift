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
    var countdown: Double = 5.0
    var primary: Double = 10.0
    var cooldown: Double = 5.0
    
    //Visual Design Variables
    var inset: CGFloat = 8.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    
    //CoreGraphics Layers
    let countdownLayer = CAShapeLayer()
    let primaryLayer = CAShapeLayer()
    let cooldownLayer = CAShapeLayer()
    
    let indicatorLayer = CALayer()
    var indicatorLayerRadius: CGFloat = 10.0
    let intervalLayers: [CALayer] = []
    var intervalLayerWidth: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        countdownLayer.backgroundColor = trackColor
        layer.addSublayer(countdownLayer)
        
        layer.addSublayer(primaryLayer)
        layer.addSublayer(cooldownLayer)
        
        indicatorLayer.backgroundColor = indicatorColor
        layer.addSublayer(indicatorLayer)
        
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        drawTrack(startAngle: 0.0, endAngle:  CGFloat(valueToRadians(countdown)), color: UIColor.red.cgColor, layer: countdownLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(countdown)), endAngle:  CGFloat(valueToRadians(primary + countdown)), color: UIColor.blue.cgColor, layer: primaryLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(primary + countdown)), endAngle:  CGFloat(valueToRadians(time)), color: UIColor.green.cgColor, layer: cooldownLayer)
    }
    
    func drawTrack(startAngle: CGFloat, endAngle: CGFloat, color: CGColor, layer: CAShapeLayer) {
        let radius: CGFloat = min(bounds.size.width/2 - inset, bounds.size.height/2 -  inset)
        let circleTrack = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius),
            radius: CGFloat(radius - CGFloat(trackWidth / 2)),
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        layer.path = circleTrack.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = CGFloat(trackWidth)
//        layer.strokeEnd = 0.0
        
        layer.setNeedsDisplay()
    }
    
    func animateCircle(duration: Double, layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: "linear")
        
        layer.strokeEnd = 1.0
        layer.add(animation, forKey: "animateCircle")
    }
    
    func positionForValue(value: Double) -> CGPoint {
        let r = valueToRadians(value)
        let radius = Double(bounds.size.width/2 - inset)
        let xCord = radius * cos(r) + Double(bounds.size.width/2)
        let yCord = radius * sin(r) + Double(bounds.size.width/2)
        return CGPoint(x: xCord, y: yCord)
    }
    
    //Converts a value to it's corresponding radian value as compared to total time
    func valueToRadians(_ value: Double) -> Double {
        return (2 * M_PI) * (value / time)
    }
    

}
