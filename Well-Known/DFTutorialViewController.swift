//
//  DFTutorialViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2015/01/02.
//  Copyright (c) 2015年 DualFang. All rights reserved.
//

import UIKit

class DFTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let page = EAIntroPage()
//        page.title = "ようこそWell-Knownへ"
        
        var page1 = EAIntroPage()
        page1.title = "ようこそWell-Knownへ"
        page1.desc = "Page 1 description"
        page1.bgImage = UIImage(named: "config_01.png")
        
        var page2 = EAIntroPage()
        page2.title = "Title 2"
        page2.desc = "Page 2 description"
        
        var introView = EAIntroView(frame: self.view.frame, andPages: [page1, page2])
        introView.showInView(self.view, animateDuration: 0.3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
