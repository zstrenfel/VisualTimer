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
    var started: Bool = false
    var paused: Bool = false
    var countdown: Double = 5.0
    var primary: Double = 10.0
    var cooldown: Double = 5.0
    var time: Double = 20.0
    
    var interval: Double? = 2.0
    let intervalRepeat: Bool = true
    
    //Visual Design Variables
    var inset: CGFloat = 60.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var degreeOfRotation: Double = M_PI_2
    
    //CoreGraphics Layers
    let startIndicator = CAShapeLayer()
    
    let countdownLayer = CAShapeLayer()
    let countdownIndicator = CAShapeLayer()
    
    let primaryLayer = CAShapeLayer()
    let primaryIndicator = CAShapeLayer()
    
    let cooldownLayer = CAShapeLayer()
    
    let indicatorLayer = CALayer()
    var indicatorRadius: CGFloat = 5.0
    var intervalLayers: [CAShapeLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        layer.addSublayer(countdownLayer)
        layer.addSublayer(primaryLayer)
        layer.addSublayer(cooldownLayer)
        
        layer.addSublayer(startIndicator)
        layer.addSublayer(countdownIndicator)
        layer.addSublayer(primaryIndicator)
        
        if interval != nil {
            let intervalCount = !intervalRepeat ? 1 : Int(floor(primary/interval!))
            for _ in 0..<intervalCount {
                let intervalLayer = CAShapeLayer()
                intervalLayers.append(intervalLayer)
                layer.addSublayer(intervalLayer)
            }
        }
        
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        drawTrack(startAngle: CGFloat(valueToRadians(0.0)), endAngle:  CGFloat(valueToRadians(countdown)), color: UIColor.lightGray.cgColor, layer: countdownLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(countdown)), endAngle:  CGFloat(valueToRadians(primary + countdown)), color: UIColor.gray.cgColor, layer: primaryLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(primary + countdown)), endAngle:  CGFloat(valueToRadians(time)), color: UIColor.lightGray.cgColor, layer: cooldownLayer)
        
        drawIndicator(position: positionForValue(value: 0.0), color: UIColor.darkGray.cgColor, layer: startIndicator)
        drawIndicator(position: positionForValue(value: countdown), color: UIColor.darkGray.cgColor, layer: countdownIndicator)
        drawIndicator(position: positionForValue(value: primary + countdown), color: UIColor.darkGray.cgColor, layer: primaryIndicator)
        
        if interval != nil {
            for i in 0..<intervalLayers.count {
                let intervalVal = interval! * Double(i + 1)
                if intervalVal != primary {
                    drawInterval(midpoint: positionForValue(value: intervalVal + countdown), value: intervalVal + countdown, color: UIColor.darkGray.cgColor, layer: intervalLayers[i])
                }
            }
        }
    }
    
    
    // MARK: - Animation Functions
    func beginAnimation() {
        started = true
        paused = false
        animateCircle(duration: countdown, beginTime: CACurrentMediaTime(), layer: countdownLayer, callback: nil)
        animateCircle(duration: primary, beginTime:  CACurrentMediaTime() + countdown, layer: primaryLayer, callback: nil)
        animateCircle(duration: cooldown, beginTime:  CACurrentMediaTime() + primary + countdown, layer: cooldownLayer, callback: nil)
    }
    
    func pauseAnimation() {
        paused = true
        let pausedTime = CACurrentMediaTime() - countdownLayer.beginTime

        countdownLayer.speed = 0.0
        countdownLayer.timeOffset = pausedTime
        
        primaryLayer.speed = 0.0
        primaryLayer.timeOffset = pausedTime
        
        cooldownLayer.speed = 0.0
        cooldownLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        paused = false
        let pausedTime = countdownLayer.timeOffset
        var timeSincePaused: CFTimeInterval
        
        countdownLayer.speed = 1.0
        countdownLayer.timeOffset = 0.0
        countdownLayer.beginTime = 0.0
        timeSincePaused = countdownLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        countdownLayer.beginTime = timeSincePaused
        
        primaryLayer.speed = 1.0
        primaryLayer.timeOffset = 0.0
        primaryLayer.beginTime = 0.0
        primaryLayer.beginTime = timeSincePaused
        
        cooldownLayer.speed = 1.0
        cooldownLayer.timeOffset = 0.0
        cooldownLayer.beginTime = 0.0
        cooldownLayer.beginTime = timeSincePaused
    }
    
    func clearAnimations() {
        started = false
        paused = false
        
        clearLayerAnimation(layer: countdownLayer)
        clearLayerAnimation(layer: primaryLayer)
        clearLayerAnimation(layer: cooldownLayer)
    }
    
    func clearLayerAnimation(layer: CAShapeLayer) {
        layer.removeAllAnimations()
        layer.speed = 1.0
        layer.timeOffset = 0.0
    }
    
    func animateCircle(duration: Double, beginTime: Double, layer: CAShapeLayer, callback: (() -> Void)?) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = beginTime
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: "linear")
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "animateCircle")
    }
    
    // MARK: - Drawing Functions
    func drawTrack(startAngle: CGFloat, endAngle: CGFloat, color: CGColor, layer: CAShapeLayer) {
        let radius: CGFloat = min(bounds.size.width/2 - inset, bounds.size.height/2 - inset)
        let circleTrack = UIBezierPath(
            arcCenter: CGPoint(x: bounds.size.width/2, y: bounds.size.height/2),
            radius: CGFloat(radius - CGFloat(trackWidth / 2)),
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        layer.path = circleTrack.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = CGFloat(trackWidth)
        layer.strokeEnd = 0.0
        layer.lineCap = kCALineCapRound
        
        layer.setNeedsDisplay()
    }
    
    func drawInterval(midpoint: CGPoint?, value: Double, color: CGColor, layer: CAShapeLayer) {
        if let mid = midpoint {
            let path = UIBezierPath()
            var startPoint = CGPoint()
            var endPoint = CGPoint()
            
            let angle = valueToRadians(value)
            startPoint.x = mid.x + CGFloat((trackWidth/2) * cos(angle))
            startPoint.y = mid.y + CGFloat((trackWidth/2) * sin(angle))
            
            endPoint.x = mid.x + CGFloat((-trackWidth/2) * cos(angle))
            endPoint.y = mid.y + CGFloat((-trackWidth/2) * sin(angle))
            
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            layer.path = path.cgPath
            layer.fillColor = color
            layer.strokeColor = color
            layer.lineWidth = 2.0
            layer.lineCap = kCALineCapRound
            
            layer.setNeedsDisplay()
        }
    }
    
    func drawIndicator(position: CGPoint?, color: CGColor, layer: CAShapeLayer) {
        if let pos = position {
            let indicator = UIBezierPath(
                arcCenter: CGPoint(x: pos.x, y: pos.y),
                radius: CGFloat(indicatorRadius),
                startAngle: 0,
                endAngle: CGFloat(2 * M_PI),
                clockwise: true)
            layer.path = indicator.cgPath
            
            layer.fillColor = color
            layer.setNeedsDisplay()
        }
    }
    
    // MARK: - Utilities
    func positionForValue(value: Double) -> CGPoint? {
        let r = valueToRadians(value)
        let radius = Double(bounds.size.width/2 - inset)
        let xCord = (radius - trackWidth/2) * cos(r) + Double(bounds.size.width/2)
        let yCord = (radius - trackWidth/2) * sin(r) + Double(bounds.size.height/2)
        
        return CGPoint(x: xCord, y: yCord)
    }
    
    //Converts a value to it's corresponding radian value as compared to total time
    func valueToRadians(_ value: Double) -> Double {
        let angle = (2 * M_PI) * (value / time)
        let translatedAngle = angle + degreeOfRotation
        return translatedAngle
    }
    

}
