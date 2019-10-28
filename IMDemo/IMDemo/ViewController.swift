//
//  ViewController.swift
//  IMDemo
//
//  Created by 张恒 on 2019/5/29.
//  Copyright © 2019 张恒. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var player: STKAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        
        let player = STKAudioPlayer()
        player.play("http://www.abstractpath.com/files/audiosamples/sample.mp3")
        
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = ChatViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
}

