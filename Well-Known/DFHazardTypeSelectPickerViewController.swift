//
//  DFHazardTypeSelectPickerViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2015/01/08.
//  Copyright (c) 2015年 DualFang. All rights reserved.
//

import UIKit

class DFHazardTypeSelectPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pic = UIPickerView()
    let text = UILabel()
    let nextButton = UIButton()
    let cancelButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.text = "追加する災害警戒エリアの種類を\n選択して\"次へ\"を押してください"
        
        text.numberOfLines = 0
        text.sizeToFit()
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        view.addSubview(text)
        initPicerView()
        initButton()
        
        
        resetAllLayout()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - pickerView DelegateMethods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch row {
        case 0:
            return "津波"
        case 1:
            return "土砂"
        case 2:
            return "洪水"
        default:
            break
        }
        return ""
    }
    
    

    func initPicerView() {
        pic.delegate = self
        pic.dataSource = self
        pic.showsSelectionIndicator = true
        
        view.addSubview(pic)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        resetAllLayout()
    }
    
    func resetAllLayout() {
        pic.frame = CGRectMake(0, 0, view.bounds.width, 216.0)
        pic.center = view.center
        
//        pic.layer.position = CGPoint(x: view.bounds.width / 2.0, y: view.bounds.height)
        
        text.center = view.center
        text.center.y = pic.center.y - text.frame.height - pic.frame.height / 4.0
        
        nextButton.center.x = view.bounds.width / 4.0 * 3.0
        nextButton.center.y = view.bounds.height - nextButton.frame.height
        
        cancelButton.center.x = view.bounds.width / 4.0 * 1.0
        cancelButton.center.y = view.bounds.height - cancelButton.frame.height
    }
    
    func initButton() {
        nextButton.setTitle("次へ", forState: UIControlState.Normal)
        nextButton.sizeToFit()
        nextButton.addTarget(self, action: "touchNextButton:", forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        view.addSubview(nextButton)
        
        
        cancelButton.setTitle("キャンセル", forState: .Normal)
        cancelButton.sizeToFit()
        cancelButton.addTarget(self, action: "touchCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        view.addSubview(cancelButton)
    }
    
    func touchNextButton(sender:UIButton) {
        DFHomeViewController.addFlag = true
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let nb = sb.instantiateInitialViewController() as UINavigationController
        presentViewController(nb, animated: true, completion: nil)
        
        let no:Int = pic.selectedRowInComponent(0)
        let type = HazardType(rawValue: no)
        DFHomeViewController.selectTag = type!
    }
    
    func touchCancelButton(sender:UIButton) {
        DFHomeViewController.addFlag = false
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let nb = sb.instantiateInitialViewController() as UINavigationController
        presentViewController(nb, animated: true, completion: nil)
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
