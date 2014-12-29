//
//  DFHomeViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/25.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit
import MapKit

class DFHomeViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    let pic = UIPickerView()
    let displayButton = UIButton()
    let map = MKMapView()
    let locationManager = CLLocationManager()
    let moveNowPositionButton = UIButton() // ユーザの現在地に視点を戻す
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        initNavigation()
        initMap()
        initLocationManager()
        initMoveNowPositionButton()
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

// MARK: - Navigation
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
//        TODO: 表示させる災害の種類を選択させるものをモーダルで表示
        modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        view.opaque = false

        let next = DFPicerViewController()
        next.definesPresentationContext = true
        next.providesPresentationContextTransitionStyle = true
        next.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        next.view.opaque = false
        presentViewController(next, animated: true, completion: nil)
    }
    
// MARK: - LocationManager
    func initLocationManager() {
        locationManager.delegate = self
        if( atof(UIDevice.currentDevice().systemVersion) >= 8.0 ) {
            // iOS8の場合は、以下の何れかの処理を追加しないと位置の取得ができない
            // アプリが非アクティブな場合でも位置取得する場合
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
// MARK: DelegateMethods
    // 位置情報が更新されるたびに呼ばれる
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        // TODO: ピンの更新処理かな？
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // TODO: ピンの更新処理かな？
    }

// MARK: - map
    func initMap() {
        map.delegate = self

        map.frame = view.bounds
        // マップにユーザの現在示
        map.showsUserLocation = true
        // マップの中心地がユーザの現在地を追従するように設定
        map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        view.addSubview(map)
    }

// MARK: - moveNowPositionButton
    func initMoveNowPositionButton() {
        //表示されるテキスト
        moveNowPositionButton.setTitle("現在地", forState: .Normal)
        
        //テキストの色
        moveNowPositionButton.setTitleColor(UIColor.redColor(), forState: .Normal)

        
        
        let kButtonWidth:CGFloat  = view.bounds.width  * 0.25
        let kButtonHeight:CGFloat = kButtonWidth * 0.5
        
        //サイズ
        moveNowPositionButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonHeight)
        
        // ボーダー
        moveNowPositionButton.layer.borderWidth = 1.0
        
        moveNowPositionButton.layer.borderColor = UIColor.redColor().CGColor
        
        //配置場所
//        moveNowPositionButton.layer.position = CGPoint(
//            x: kButtonWidth / 2.0 + view.bounds.width * 0.1,
//            y:view.bounds.height - kButtonHeight)
        moveNowPositionButton.layer.position = CGPoint(
            x: view.bounds.width - kButtonWidth / 2.0 - view.bounds.width * 0.1,
            y:view.bounds.height - kButtonHeight)

        
        //ボタンをタップした時に実行するメソッドを指定
        moveNowPositionButton.addTarget(self, action: "touchMoveNowPositionButton:", forControlEvents:.TouchUpInside)
        
        view.addSubview(moveNowPositionButton)
    }
    
    func touchMoveNowPositionButton(button: UIButton) {
        map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
// MARK: - OverrideMethods
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        switch fromInterfaceOrientation {
        case UIInterfaceOrientation.Portrait:
            NSLog("portrait")
            map.frame = view.bounds
            break
        case UIInterfaceOrientation.LandscapeLeft:
            NSLog("LandscapeLeft")
            map.frame = view.bounds
            break
        case UIInterfaceOrientation.LandscapeRight:
            NSLog("LandscapeRight")
            map.frame = view.bounds
            break
        default:
            break
        }
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
