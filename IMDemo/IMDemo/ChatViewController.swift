//
//  ChatViewController.swift
//  IMDemo
//
//  Created by 张恒 on 2019/6/3.
//  Copyright © 2019 张恒. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController,TChatControllerDelegate {
    func chatControllerDidClickRightBarButton(_ controller: TChatController!) {
        
    }
    
    func chatController(_ chatController: TChatController!, didSelectMoreAt index: Int) {
        
    }
    
    func chatController(_ chatController: TChatController!, didSelectMessages msgs: NSMutableArray!, at index: Int) {
        
    }
    
    var chat :TChatController?
    private var conversation:TIMConversation!
    var sessionId  =  ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionId = "g_233"
//        sessionId = "252"
        
        
        
        chat = TChatController.init()
        let cellData = TConversationCellData()
        cellData.convType = TConvType(rawValue: 2)!;
        //会话ID
        cellData.convId = sessionId
        chat?.conversation = cellData
        chat?.delegate = (self as TChatControllerDelegate)
        addChild(chat!)
        view.addSubview(chat!.view)
        
        
        
   
        conversation = TIMManager.sharedInstance().getConversation(.GROUP, receiver: sessionId)
        
        TIMGroupManager.sharedInstance()?.modifyReciveMessageOpt(sessionId, opt: TIMGroupReceiveMessageOpt(rawValue: 2)! , succ: {
            print("修改接收群消息选项")
        }, fail: { (code, msg) in
            print(code)
        })

        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TIMGroupManager.sharedInstance()?.getReciveMessageOpt(sessionId, succ: { (messageOpt) in
            print(messageOpt)
            
        }, fail:  { (code, msg) in
            
        })
        
    }

}
