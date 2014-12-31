//
//  DFConfigController.swift
//  Well-Known
//
//  Created by hw14d002 on 2014/12/30.
//  Copyright (c) 2014年 DualFang. All rights reserved.
//

import UIKit

class DFConfigController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var configTableView: UITableView!

    
    
    let imgArray: NSArray = ["config_01.png", "config_02.png", "config_03.png"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.redColor()
        navigationItem.title = "設定"
        
        var nib  = UINib(nibName: "DFConfigTableViewCell", bundle:nil)
        configTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
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
        
        var img = UIImage(named:"\(imgArray[indexPath.row])")

        // tableCell の ID で UITableViewCell のインスタンスを生成
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Tag番号 1 で UIImageView インスタンスの生成
        var imageView = tableView.viewWithTag(1) as UIImageView
        imageView.image = img
        
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = tableView.viewWithTag(2) as UILabel
        label1.text = "No.\(indexPath.row + 1)"
        
        
        return cell
    }
    
    // 行の高さ
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 60
    }
}
