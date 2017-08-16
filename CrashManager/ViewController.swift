//
//  ViewController.swift
//  CrashManager
//
//  Created by mouruiXY on 2017/8/16.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        let signalBtn = UIButton(frame: CGRect(x: 80, y: 100, width: 160, height: 40))
        signalBtn.setTitle("signalCrash", for: .normal)
        signalBtn.addTarget(self, action: #selector(signalBtnAct), for: .touchUpInside)
        self.view.addSubview(signalBtn)
        
        let exceptionBtn = UIButton(frame: CGRect(x: 80, y: 160, width: 160, height: 40))
        exceptionBtn.setTitle("exceptionCrash", for: .normal)
        exceptionBtn.addTarget(self, action: #selector(exceptionBtnAct), for: .touchUpInside)
        self.view.addSubview(exceptionBtn)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    //NSException crash
    func exceptionBtnAct(){
        let ttaar = NSArray()
        print(ttaar[66])
    }
    
    //signal crash
    func signalBtnAct(){
        
        let filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        //crash存储位置
        print(filePath)
        
        var strr:String!
        strr = strr + "...."
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

