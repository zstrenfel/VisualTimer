//
//  VisualTimerIndicatorLayer.swift
//  VisualTimer
//
//  Created by Zach Strenfel on 3/21/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit
import QuartzCore

class VisualTimerIndicatorLayer: CALayer {
    weak var visualTimer: VisualTimer?
    
    override func draw(in ctx: CGContext) {
        if let _ = visualTimer {
            let indicatorFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
            let cornerRadius = bounds.height/2.0
            let indicatorPath = UIBezierPath(roundedRect: indicatorFrame, cornerRadius: cornerRadius)
            
            ctx.addPath(indicatorPath.cgPath)
            ctx.setFillColor(UIColor.blue.cgColor)
            ctx.fillPath()
        }
    }
}
