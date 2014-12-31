//
//  DFHomeViewController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/25.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit
import MapKit

enum NavigationItemTag: Int {
    case kLeft,
    kRight,
    kCenter
}

class DFHomeViewController: ViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate,CLLocationManagerDelegate {
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
        
        resetAllLayout()
    
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
        initNavigationBarItem()
    }
    
// MARK: 表示させる災害の変更するためのボタン
    func initDisplayButton() {
        //表示されるテキスト
        displayButton.setTitle("全ての災害", forState: .Normal)
        
        //テキストの色
        displayButton.setTitleColor(UIColor.redColor(), forState: .Normal)

        
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
    
    func setLayoutDisplayButton() {
        //サイズ
        displayButton.frame = CGRectMake(0, 0, 60, 30)
        
        //配置場所
        displayButton.layer.position = CGPoint(x: 0, y:0)
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

        // マップにユーザの現在示
        map.showsUserLocation = true
        // マップの中心地がユーザの現在地を追従するように設定
        map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        view.addSubview(map)
    }
    
    func setLayoutMap() {
        map.frame = view.bounds
    }

// MARK: - moveNowPositionButton
    func initMoveNowPositionButton() {
        
        moveNowPositionButton.setTitle("現在地", forState: .Normal)

        moveNowPositionButton.setTitleColor(UIColor.redColor(), forState: .Normal)

        moveNowPositionButton.layer.borderWidth = 1.0
        
        moveNowPositionButton.layer.borderColor = UIColor.redColor().CGColor
        
        moveNowPositionButton.addTarget(self, action: "touchMoveNowPositionButton:", forControlEvents:.TouchUpInside)
        
        view.addSubview(moveNowPositionButton)
    }
    
    func touchMoveNowPositionButton(button: UIButton) {
        map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
    }
    
    func setLayoutMoveNowPositionButton() {
        let kButtonWidth:CGFloat  = 60//view.bounds.width  * 0.25
        let kButtonHeight:CGFloat = kButtonWidth * 0.5
        
        moveNowPositionButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonHeight)
        
        moveNowPositionButton.layer.position = CGPoint(
            x: view.bounds.width - kButtonWidth / 2.0 - view.bounds.width * 0.1,
            y:view.bounds.height - kButtonHeight)
    }
    
// MARK: - OverrideMethods
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        resetAllLayout()
    }
    
// MARK: - Layout
    // 全てのパーツを配置しなおす
    func resetAllLayout() {
        setLayoutDisplayButton()
        setLayoutMap()
        setLayoutMoveNowPositionButton()
    }
// MARK: -
    func touchNavigationItem(button: UIButton) {
        
        //presentViewController(n, animated: true, completion: nil)
        if let tag = NavigationItemTag(rawValue: button.tag) {
            switch tag {
            case .kCenter:
                break
            case .kRight:
                break
            case .kLeft:
                if (navigationController != nil) {
                    let nextStoryBorad = UIStoryboard(name: "Config", bundle: NSBundle.mainBundle())
                    let configVC = nextStoryBorad.instantiateInitialViewController() as DFConfigController
                    navigationController?.pushViewController(configVC, animated: true)
                }else {
                    println("navigationController is null pointer")
                }
                break
            default:
                break
            }
        }else {
            println("There isn't a planet at position \(button.tag)")
        }
        
    }
// MARK: - navigation
    func initNavigationBarItem() {
        let leftItem = UIBarButtonItem(title: "設定", style: .Plain, target: self, action: "touchNavigationItem:")
        leftItem.tag = NavigationItemTag.kLeft.rawValue
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: "touchNavigationItem:")
        rightItem.tag = NavigationItemTag.kRight.rawValue
        navigationItem.rightBarButtonItem = rightItem
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
