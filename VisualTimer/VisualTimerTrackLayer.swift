//
//  VisualTimerTrackLayer.swift
//  VisualTimer
//
//  Created by Zach Strenfel on 3/20/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit
import QuartzCore

class VisualTimerTrackLayer: CALayer {
    
    weak var visualTimer: VisualTimer?
    var strokeStart: Double = 0.0
    
    override func draw(in ctx: CGContext) {
        if let timer = visualTimer {
            let halfSize: CGFloat = min(bounds.size.width/2 - 10.0, bounds.size.height/2 - 10.0) //magic numbers
            
            
            let circleTrack = UIBezierPath(
                arcCenter: CGPoint(x: halfSize, y: halfSize),
                radius: halfSize,
                startAngle: CGFloat(timer.valueToRadians(timer.startPoint)),
                endAngle: CGFloat(timer.valueToRadians(timer.currTime)),
                clockwise: true)
            
            
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.setStrokeColor(timer.trackColor)
            ctx.setLineCap(CGLineCap.round)
            ctx.setLineWidth(CGFloat(timer.trackWidth))
            ctx.addPath(circleTrack.cgPath)
            ctx.drawPath(using: .stroke)
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = self.strokeStart
            animation.toValue = timer.currTime/timer.time
            animation.duration = 1
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            self.add(animation, forKey: animation.keyPath)
            self.strokeStart = timer.currTime/timer.time
        }
    }
}
