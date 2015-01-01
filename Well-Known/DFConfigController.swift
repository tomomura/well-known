//
//  DFConfigController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/30.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit

enum HazardType:Int {
    case Tsunami=0, // 津波
    Inundation,     // 浸水
    Landslide,      // 土砂
    Count           // 種類数
}

class DFConfigController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var configTableView: UITableView!
    
    
    
    let imgArray: NSArray = ["config_01.png", "config_02.png", "config_03.png"]
    let hazardTypeString: NSArray = ["津波", "土砂", "浸水"]
    
    // Sectionで使用する配列を定義する.
    let mySections: NSArray = ["災害予想エリアお知らせ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "設定"
        
        // 自作セルを設定
        var nib  = UINib(nibName: "DFConfigTableViewCell", bundle:nil)
        configTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        configTableView.allowsSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableViewDelegateMethods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //各セルの要素を設定する
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        // tableCell の ID で UITableViewCell のインスタンスを生成
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        // アイコン設定
        var img = UIImage(named:"\(imgArray[indexPath.row])")
        let imageView = tableView.viewWithTag(1) as UIImageView
        imageView.image = img
        
        // 種類テキスト
        let label1 = tableView.viewWithTag(2) as UILabel
        label1.text = hazardTypeString[indexPath.row] as NSString
        
        // ON,OFFスイッチのアクション設定
        let hazardSwitch = tableView.viewWithTag(3) as UISwitch
        hazardSwitch.addTarget(self, action: "changeSwitch:", forControlEvents: UIControlEvents.ValueChanged)
        
        // タグで識別するようにする
        hazardSwitch.tag = indexPath.row
        
        return cell
    }
    
    // 行の高さ
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 50
    }
    
    // セクションの数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mySections.count
    }
    
    // セクションタイトル
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "災害注意エリアお知らせ"
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "“災害注意エリアお知らせ”は登録されている\n災害エリアに近づくとPush通知でお知らせします"
    }
    
    
    // MARK: - UISwitch
    func changeSwitch(sender:UISwitch) {
        if sender.on {
            sender.superview
           println("switch on \(sender.tag)")
        }else {
            println("switch off \(sender.tag)")
        }
        
        
        if let type = HazardType(rawValue: sender.tag) {
            switch type {
            case .Tsunami:
                break
            case .Inundation:
                break
            case .Landslide:
                break
            default:
                break
            }
        }else {
            println("HazardType is not found\(sender.tag)")
        }
    }
}
