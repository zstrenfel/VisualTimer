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
    
    var timer: Timer? = nil
    
    @IBAction func startTimer(_ sender: UIButton) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
            self.visualTimer?.currTime = 0.0
        }
    }
    
    func update() {
        self.visualTimer?.currTime += 1
    }
    
    let exampleTimer: ExampleTimer = ExampleTimer(countdown: 5.0, cooldown: 5.0, primary: 10.0, interval: 0.0)
    var visualTimer: VisualTimer? = nil

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

