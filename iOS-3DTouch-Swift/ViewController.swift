//
//  ViewController.swift
//  iOS-3DTouch-Swift
//
//  Created by eidan on 17/1/22.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "3D Touch Demo"
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func goToTouchVC(_ sender: Any) {
        let touchVC: TouchViewController = TouchViewController(nibName: "TouchViewController", bundle: nil)
        self.navigationController?.pushViewController(touchVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

