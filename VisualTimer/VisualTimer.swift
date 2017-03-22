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
    var paused: Bool = true
    var countdown: Double = 5.0
    var primary: Double = 10.0
    var cooldown: Double = 5.0
    var time: Double = 20.0
    
    var interval: Double? = 2.0
    let intervalRepeat: Bool = true
    
    //Visual Design Variables
    var inset: CGFloat = 8.0
    var trackWidth: Double = 10.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0).cgColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    
    //CoreGraphics Layers
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
        
        layer.addSublayer(countdownIndicator)
        layer.addSublayer(primaryIndicator)
        
        
        if interval != nil {
            if !intervalRepeat {
                let intervalLayer = CAShapeLayer()
                intervalLayers.append(intervalLayer)
                layer.addSublayer(intervalLayer)
            } else {
                let intervalCount = Int(floor(primary/interval!))
                for _ in 0..<intervalCount {
                    let intervalLayer = CAShapeLayer()
                    intervalLayers.append(intervalLayer)
                    layer.addSublayer(intervalLayer)
                }
            }
        }
        
        updateLayerFrames()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        drawTrack(startAngle: 0.0, endAngle:  CGFloat(valueToRadians(countdown)), color: UIColor.red.cgColor, layer: countdownLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(countdown)), endAngle:  CGFloat(valueToRadians(primary + countdown)), color: UIColor.blue.cgColor, layer: primaryLayer)
        drawTrack(startAngle: CGFloat(valueToRadians(primary + countdown)), endAngle:  CGFloat(valueToRadians(time)), color: UIColor.green.cgColor, layer: cooldownLayer)
        drawIndicator(position: positionForValue(value: countdown), color: UIColor.yellow.cgColor, layer: countdownIndicator)
        drawIndicator(position: positionForValue(value: primary + countdown), color: UIColor.magenta.cgColor, layer: primaryIndicator)
        
        if interval != nil {
            for i in 0..<intervalLayers.count {
                let intervalVal = interval! * Double(i + 1)
                if intervalVal != primary {
                    drawIndicator(position: positionForValue(value: intervalVal + countdown), color: UIColor.brown.cgColor, layer: intervalLayers[i])
                }
            }
        }
        
        animateCircle(duration: countdown, beginTime: CACurrentMediaTime(), layer: countdownLayer, callback: nil)
        animateCircle(duration: primary, beginTime:  CACurrentMediaTime() + countdown, layer: primaryLayer, callback: nil)
        animateCircle(duration: cooldown, beginTime:  CACurrentMediaTime() + primary + countdown, layer: cooldownLayer, callback: nil)
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
        layer.strokeEnd = 0.0
        
        layer.setNeedsDisplay()
    }
    
    func animateCircle(duration: Double, beginTime: Double, layer: CAShapeLayer, callback: (() -> Void)?) {
        CATransaction.begin()

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: "linear")
        animation.beginTime = beginTime
        animation.fillMode = kCAFillModeBackwards
        
        layer.strokeEnd = 1.0
        
        layer.add(animation, forKey: "animateCircle")
        
        CATransaction.commit()
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
    
    func positionForValue(value: Double) -> CGPoint? {
        guard value > 0.0 else {
            return nil
        }
        
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
