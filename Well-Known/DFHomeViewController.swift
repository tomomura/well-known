//
//  DFHomeViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/25.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit

class DFHomeViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let pic = UIPickerView()
    let displayButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        initNavigation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "test"
    }
    
    func initNavigation() {
        initDisplayButton()
    }
    
// MARK: 表示させる災害の変更するためのボタン
    func initDisplayButton() {
        //表示されるテキスト
        displayButton.setTitle("全ての災害", forState: .Normal)
        
        //テキストの色
        displayButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        
        //タップした状態のテキスト
//        displayButton.setTitle("Tapped!", forState: .Highlighted)
        
        //タップした状態の色
//        displayButton.setTitleColor(, forState: .Highlighted)
        
        //サイズ
        displayButton.frame = CGRectMake(0, 0, 60, 30)
        
        //タグ番号
//        displayButton.tag = 1
        
        //配置場所
        displayButton.layer.position = CGPoint(x: 0, y:0)
        
        //ボタンをタップした時に実行するメソッドを指定
        displayButton.addTarget(self, action: "touchDisplayButton:", forControlEvents:.TouchUpInside)
        
        navigationItem.titleView = displayButton
    }
    
    func touchDisplayButton(button: UIButton) {
//        button.setTitle("押された災害", forState: .Normal)
//        TODO: 表示させる災害の種類を選択させるものをモーダルで表示

        modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
//        definesPresentationContext = YES
//        self.providesPresentationContextTransitionStyle = YES
        
        let next = DFPicerViewController()
        next.definesPresentationContext = true
        next.providesPresentationContextTransitionStyle = true
        next.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        
        presentViewController(next, animated: true, completion: nil)
    }

// MARK: ピッカービュー

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
