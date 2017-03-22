//
//  ViewController.swift
//  VisualTimer
//
//  Created by Zach Strenfel on 3/20/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let visualTimer = VisualTimer(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        visualTimer.backgroundColor = UIColor.red
        view.addSubview(visualTimer)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        visualTimer.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: width)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animate(_ sender: UIButton) {
        if visualTimer.started {
            if visualTimer.paused {
                visualTimer.resumeAnimation()
            } else {
                visualTimer.pauseAnimation()
            }
        } else {
            visualTimer.beginAnimation()
        }
    }

    @IBAction func clearAnimations(_ sender: UIButton) {
        visualTimer.clearAnimations()
    }
}

