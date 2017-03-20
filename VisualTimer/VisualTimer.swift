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
    
//    var frame: CGRect 
//    weak var delegate: VisualTimerDelegate? = nil
    var currLocation: CGPoint = CGPoint()
    
    //Time Variables
    var time: Double = 0.0
    var paused: Bool = true
    var interval: Double? = nil
    var countdown: Double = 0.0
    var cooldown: Double = 0.0
    
    //Visual Design Variables
    var trackWeight: Double = 1.0
    var trackColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0) as! CGColor
    var indicatorColor: CGColor = UIColor(red: 82/255, green: 179/255, blue: 217/255, alpha: 1.0) as! CGColor
    var timerRadius: Double = 100.0
    var timerSpeed: Double = 0.5
    
    //CoreGraphics Layers
    let trackLayer = CALayer()
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
        
        for interval in intervalLayers {
            //crete interval layers here
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
