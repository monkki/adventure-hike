//
//  ViewController.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 03/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import VideoSplashKit

class ViewController: VideoSplashViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = false
        self.startTime = 0.0
        self.duration = 9.0
        self.alpha = 1.0
        self.backgroundColor = UIColor.clearColor()
        self.contentURL = url
        self.restartForeground = true
        
        if NSUserDefaults.standardUserDefaults().objectForKey("tokenServer") != nil {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("inicioSegue2", sender: self)
            })
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }

}

