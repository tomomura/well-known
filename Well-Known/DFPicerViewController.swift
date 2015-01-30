//
//  DFPicerViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/26.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit

class DFPicerViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let pic = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        view.sizeThatFits(CGSize(width: 300, height: 200))
        initPicerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "test"
    }
    
    // MARK: ピッカービュー
    func initPicerView() {
        pic.center = view.center
        pic.frame = CGRectMake(0, view.bounds.height - 162.0 - 300.0, view.bounds.width, 162.0)
        pic.delegate = self
        pic.dataSource = self
        view.addSubview(pic)
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
