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

struct HazardSpot {
    var height = 0.0
    var width = 0.0
    var radian = 0.0
    var centerLatitude = 0.0
    var centerLongitude = 0.0
    var tag = ""
}

struct RectDouble {
    var top:Double = 0.0
    var bottom:Double = 0.0
    var left:Double = 0.0
    var right:Double = 0.0
}

struct PointDouble {
    internal var x:Double = 0.0
    internal var y:Double = 0.0
}



class DFHomeViewController: ViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    // 代替案
    private struct ClassProperty {
        // stuctでは静的変数の宣言が可能
        static var addFlag = false
        
        static var selectTag = HazardType.Tsunami
    }
    
    // Computed Property
    class var addFlag: Bool {
        get {
            return ClassProperty.addFlag
        }
        set {
            ClassProperty.addFlag = newValue
        }
    }
    
    class var selectTag: HazardType {
        get {
        return ClassProperty.selectTag
        }
        set {
            ClassProperty.selectTag = newValue
        }
    }
    
    let pic = UIPickerView()
    let displayButton = UIButton()
    let map = MKMapView()
    let locationManager = CLLocationManager()
    let moveNowPositionButton = UIButton() // ユーザの現在地に視点を戻す
    
    let widthScalingBar = UISlider()
    let heightScalingBar = UISlider()
    let rotateAngleBar = UISlider()
    var touchLatitude = 0.0
    var touchLongitude = 0.0
    let widthLabel = UILabel()
    let heightLabel = UILabel()
    let angleLabel = UILabel()
    let database = DFHazardSpotDatabase()
    
    var addHazardSpotOverlay:MKOverlay!
    
    var hazardSpotList = Array<HazardSpot>()
    
    var angle = 0.0
    
//    var addFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        initNavigation()
        initMap()
        initLocationManager()
        initMoveNowPositionButton()
        initAddHazardSpotUI()
        
        resetAllLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

// MARK: - Navigation
    func initNavigation() {
        initDisplayButton()
        initNavigationBarItem()
    }
    
// MARK: 表示させる災害の変更するためのボタン
    func initDisplayButton() {
        //表示されるテキスト
        displayButton.setTitle("", forState: .Normal)
        
        //テキストの色
        displayButton.setTitleColor(UIColor.redColor(), forState: .Normal)

        
        //ボタンをタップした時に実行するメソッドを指定
//        displayButton.addTarget(self, action: "touchDisplayButton:", forControlEvents:.TouchUpInside)
        
        navigationItem.titleView = displayButton
    }
    
    func touchDisplayButton(button: UIButton) {
        let pickerVC = DFHazardTypeSelectPickerViewController(nibName:"DFHazardTypeSelectPickerViewController", bundle:nil)
        
        let sheet = NAModalSheet(viewController: pickerVC, presentationStyle: NAModalSheetPresentationStyle.SlideInFromBottom)

        sheet.presentWithCompletion(nil)
        sheet.slideInset = 0
        println("moved pickerViewController")
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 最高精度
        locationManager.pausesLocationUpdatesAutomatically = false // ポーズ禁止
        locationManager.activityType = CLActivityType.Fitness
        
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
        // TO DO 当たり判定
        
        
    }

// MARK: - map
    func initMap() {
        map.delegate = self

        // マップにユーザの現在示
        map.showsUserLocation = true
        // マップの中心地がユーザの現在地を追従するように設定
        map.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        // ジェスチャー登録
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "mapTapGesture:"))

        initHazardSpotList()
        
        view.addSubview(map)
    }
    
    func setLayoutMap() {
        map.frame = view.bounds
        
        if DFHomeViewController.addFlag {
            var viewSize = CGRectMake(0, 0, view.bounds.width, view.bounds.height - 100.0)
            map.frame = viewSize
        }
    }

// MARK: - moveNowPositionButton
    func initMoveNowPositionButton() {
        
        moveNowPositionButton.setTitle("現在地", forState: .Normal)

        moveNowPositionButton.setTitleColor(UIColor.blueColor(), forState: .Normal)

        moveNowPositionButton.layer.borderWidth = 2.0
        
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
            y:map.bounds.height - kButtonHeight)
    }
    
// MARK: - OverrideMethods
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        resetAllLayout()
    }
    
// MARK: - Layout
    // 全てのパーツを配置しなおす
    func resetAllLayout() {
        updateNavigationBarItem()
        
        setLayoutDisplayButton()
        setLayoutMap()
        setLayoutMoveNowPositionButton()
        setLayoutScalingBar()
    }
    
    func setLayoutScalingBar() {
        let w = view.bounds.width * 0.7
        let h = 50.0
        let x = (view.bounds.width - w) + view.bounds.width * 0.29
        let interval:CGFloat = -30.0
        
        
        if DFHomeViewController.addFlag {
            widthLabel.hidden = false
            heightLabel.hidden = false
            angleLabel.hidden = false
            
            widthScalingBar.hidden = false
            heightScalingBar.hidden = false
            rotateAngleBar.hidden = false
        }else {
            widthLabel.hidden = true
            heightLabel.hidden = true
            angleLabel.hidden = true
            
            widthScalingBar.hidden = true
            heightScalingBar.hidden = true
            rotateAngleBar.hidden = true
        }
        
        
        widthScalingBar.frame = CGRectMake(0, 0, w, 50)
        widthScalingBar.layer.position = CGPoint(x:  x, y: view.bounds.height - 20)
//        widthScalingBar.hidden = true
        
        heightScalingBar.frame = CGRectMake(0, 0, w, 50)
        heightScalingBar.layer.position = CGPoint(x: x, y: view.bounds.height - 20 + interval)
//        heightScalingBar.hidden = true
        
        rotateAngleBar.frame = CGRectMake(0, 0, w, 50)
        rotateAngleBar.layer.position = CGPoint(x: x, y: view.bounds.height - 20 + interval * 2.0)
//        rotateAngleBar.hidden = true
        
        widthLabel.frame = CGRectMake(0, 0, 100, 50)
        widthLabel.layer.position = CGPoint(x: 55, y: view.bounds.height - 20)
        
        heightLabel.frame = CGRectMake(0, 0, 100, 50)
        heightLabel.layer.position = CGPoint(x: 55, y: view.bounds.height - 20 + interval)
        
        angleLabel.frame = CGRectMake(0, 0, 100, 50)
        angleLabel.layer.position = CGPoint(x: 55, y: view.bounds.height - 20 + interval * 2.0)
    }
// MARK: -
    func touchNavigationItem(button: UIButton) {
        
        //presentViewController(n, animated: true, completion: nil)
        if let tag = NavigationItemTag(rawValue: button.tag) {
            switch tag {
            case .kCenter:
                break
            case .kRight:
                if DFHomeViewController.addFlag {
                    let alert = UIAlertController(title: "追加確認", message: "この災害警戒エリアを追加しますか？", preferredStyle: .Alert)
                    let otherAction = UIAlertAction(title: "はい", style: .Default, handler: {
                        (action:UIAlertAction!) -> Void in
                        DFHomeViewController.addFlag = false
                        self.resetAllLayout()
                        // データベース登録処理
                    })
                    
                    let cancelAction = UIAlertAction(title: "いいえ", style: .Cancel) {
                        action in NSLog("いいえボタンが押されました")
                    }
                    
                    // addActionした順に左から右にボタンが配置されます
                    alert.addAction(otherAction)
                    alert.addAction(cancelAction)
                    
                    presentViewController(alert, animated: true, completion: nil)
                }else {
//                     災害タグ設定ピッカー
                    let nextVC = DFHazardTypeSelectPickerViewController()
                    presentViewController(nextVC, animated: false, completion: nil)
                    
//                    nextVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                    
                    let sheet = NAModalSheet(viewController: nextVC, presentationStyle: NAModalSheetPresentationStyle.SlideInFromBottom)
//                    sheet.slideInset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
//                    sheet.slideInset = UIApplication.sharedApplication().statusBarFrame.size.height + navigationController!.navigationBar.frame.size.height
//                    sheet.presentWithCompletion(nil)
 
                    DFHomeViewController.addFlag = true
                }
                
                
                resetAllLayout()
                
                break
            case .kLeft:
                if DFHomeViewController.addFlag {
                    DFHomeViewController.addFlag = false
                    resetAllLayout()
                    
                    if addHazardSpotOverlay != nil {
                        map.removeOverlay(addHazardSpotOverlay)
                    }
                }else {
                    if (navigationController != nil) {
                        let nextStoryBorad = UIStoryboard(name: "Config", bundle: NSBundle.mainBundle())
                        let configVC = nextStoryBorad.instantiateInitialViewController() as DFConfigController
                        navigationController?.pushViewController(configVC, animated: true)
                    }else {
                        println("navigationController is null pointer")
                    }
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
        
        let rightItem = UIBarButtonItem(title: "追加", style: .Plain, target: self, action: "touchNavigationItem:")
        rightItem.tag = NavigationItemTag.kRight.rawValue
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func updateNavigationBarItem() {
        if DFHomeViewController.addFlag {
            navigationItem.leftBarButtonItem?.title = "キャンセル"
            navigationItem.rightBarButtonItem?.title = "完了"
            displayButton.setTitle("追加画面", forState: .Normal)
            displayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }else {
            navigationItem.leftBarButtonItem?.title = "設定"
            navigationItem.rightBarButtonItem?.title = "追加"
            displayButton.setTitle("マップ", forState: .Normal)
            displayButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func mapTapGesture(sender: UITapGestureRecognizer){
        if !DFHomeViewController.addFlag {
            return
        }
        
        if(sender.state == UIGestureRecognizerState.Ended) {
//            println("map tap")
            
            var tapPoint = sender.locationInView(map)
            var center = map.convertPoint(tapPoint, toCoordinateFromView: map)
            touchLatitude = center.latitude
            touchLongitude = center.longitude
            
            transAddHazardSpotOverlay()
            //initHazardSpotList()
            
//            let one_distance = 110574.0 // 緯度経度の1単位のおおよその距離
//            var width = 1000.0 / one_distance
//            var height = 500.0 / one_distance
//            
//            var latitude = 34.735146
//            var longitude = 135.641691
//            
//            var ret = isHitPointAngleRect(
//                center.longitude - longitude,
//                y: center.latitude - latitude,
//                w: width,
//                h: height, r: 45.0)
//            if(ret) {
//                println("ヒット")
//            }else{
//                println("ノンヒット")
//            }
            
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if(overlay.isKindOfClass(MKPolygon)) {
                var renderer = MKPolygonRenderer(overlay: overlay)
                renderer.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
                renderer.lineWidth = 2
                renderer.strokeColor = UIColor.redColor()
                return renderer
            
        }
        return nil
    }
    
    func initHazardSpotList() {
        
    }
    

    
    func isHitPointAngleRect(x:Double, y:Double, w:Double, h:Double, r:Double) -> Bool {
        var s = sin(-r)
        var c = cos(-r)
        var xx = abs(x*c - y*s)
        var yy = abs(x*s + y*c)
        if(xx < w / 2.0 && yy < h / 2.0) {
            return true
        }
        return false
    }
    
    func addHazardSpotOnMapView(spot:HazardSpot) {
        var height = getTudeUnit(500.0)
        var width = getTudeUnit(300.0)
        var latitude = 0.0
        
        var spot = HazardSpot(height: 0, width: 0, radian: 0, centerLatitude: 0, centerLongitude: 0, tag: "")
        
    }
    
// MARK: - addHazardSpotUI
    func initAddHazardSpotUI() {
        widthScalingBar.maximumValue = 1.0
        widthScalingBar.minimumValue = 0.1
        widthScalingBar.value = 0.5
        widthScalingBar.continuous = true
        widthScalingBar.addTarget(self, action: "slideWidthScaling:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(widthScalingBar)
        
        heightScalingBar.maximumValue = 1.0
        heightScalingBar.minimumValue = 0.1
        heightScalingBar.value = 0.5
        heightScalingBar.continuous = true
        heightScalingBar.addTarget(self, action: "slideHeightScaling:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(heightScalingBar)
        
        rotateAngleBar.maximumValue = 360.0
        rotateAngleBar.minimumValue = 0.0
        rotateAngleBar.value = 0.5
        rotateAngleBar.continuous = true
        rotateAngleBar.addTarget(self, action: "slideRotateAngle:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(rotateAngleBar)
        
        widthLabel.text = "横サイズ"
        view.addSubview(widthLabel)
        
        heightLabel.text = "縦サイズ"
        view.addSubview(heightLabel)
        
        angleLabel.text = "角度"
        view.addSubview(angleLabel)
    }
    
    func slideWidthScaling(sender:UISlider) {
        transAddHazardSpotOverlay()
    }
    
    func slideHeightScaling(sender:UISlider) {
        transAddHazardSpotOverlay()
    }
    
    func slideRotateAngle(sender:UISlider) {
        transAddHazardSpotOverlay()
    }
    
    func transAddHazardSpotOverlay() {
        var latitude = touchLatitude
        var longitude = touchLongitude
        var centerY = latitude
        var centerX = longitude
        
        var width =  getTudeUnit(20000.0 * Double(widthScalingBar.value))
        var height = getTudeUnit(20000.0 * Double(heightScalingBar.value))
        
        var rcPoints = [
            PointDouble(x: -width/2.0, y: -height/2.0),
            PointDouble(x: width/2.0, y: -height/2.0),
            PointDouble(x: width/2.0, y: height/2.0),
            PointDouble(x: -width/2.0, y: height/2.0)
        ]
        
        angle = Double(rotateAngleBar.value)

        var radian = toRadian(angle)
        for i in 0 ..< rcPoints.count {
            var new_x = rcPoints[i].x * cos(radian) - rcPoints[i].y * sin(radian)
            var new_y = rcPoints[i].x * sin(radian) + rcPoints[i].y * cos(radian)
            new_x += centerX
            new_y += centerY
            rcPoints[i].x = new_x
            rcPoints[i].y = new_y
        }
        
        
        var coors = [
            CLLocationCoordinate2DMake(rcPoints[0].y, rcPoints[0].x),
            CLLocationCoordinate2DMake(rcPoints[1].y, rcPoints[1].x),
            CLLocationCoordinate2DMake(rcPoints[2].y, rcPoints[2].x),
            CLLocationCoordinate2DMake(rcPoints[3].y, rcPoints[3].x)
        ]
        var polygon = MKPolygon(coordinates: &coors, count: 4)
        
        
        if(map.overlays != nil) {
            if(map.overlays.count > 0) {
                map.removeOverlay(map.overlays[0] as MKOverlay)
            }
        }
        
        map.addOverlay(polygon)
        
        addHazardSpotOverlay = map.overlays[0] as MKOverlay
    }
}
