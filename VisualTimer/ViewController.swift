//
//  ViewController.swift
//  VisualTimer
//
//  Created by Zach Strenfel on 3/20/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit

struct ExampleTimer {
    var countdown: Double
    var cooldown: Double
    var primary: Double
    var interval: Double
}

class ViewController: UIViewController {
    
    let exampleTimer: ExampleTimer = ExampleTimer(countdown: 5.0, cooldown: 5.0, primary: 10.0, interval: 0.0)
    var
    visualTimer: VisualTimer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        visualTimer = VisualTimer(frame: CGRect.zero, timer: exampleTimer)
        
//        visualTimer.backgroundColor = UIColor.red
        view.addSubview(visualTimer!)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        visualTimer?.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: width)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

