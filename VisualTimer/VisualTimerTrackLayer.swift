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
    
    override func draw(in ctx: CGContext) {
        if let timer = visualTimer {
            let halfSize: CGFloat = min(bounds.size.width/2, bounds.size.height/2)
            let circleTrack = UIBezierPath(
                arcCenter: CGPoint(x: halfSize, y: halfSize),
                radius: halfSize,
                startAngle: CGFloat(timer.valueToRadians(timer.startPoint)),
                endAngle: CGFloat(timer.valueToRadians(timer.currTime)),
                clockwise: true)
            
            ctx.addPath(circleTrack.cgPath)
            ctx.setFillColor(UIColor.red.cgColor)
            ctx.setStrokeColor(timer.trackColor)
            ctx.setLineCap(CGLineCap.round)
            ctx.setLineWidth(CGFloat(timer.trackWidth))
            ctx.fillPath()
        }
    }
}
