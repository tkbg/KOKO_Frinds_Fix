//
//  AddFriendViewController.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/17.
//

import UIKit
import Foundation

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var kokoId: UIButton!
    @IBOutlet weak var kokoidConstrait: NSLayoutConstraint!
    var mandata:NSArray = []
    var friend4data:NSArray = []
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.friendLabel.text = NSLocalizedString("2", comment: "")
        
        self.friendLabel.layer.masksToBounds = true
        self.friendLabel.layer.cornerRadius = self.friendLabel.frame.height/2
        self.friendLabel.isHidden = true
        
        self.chatLabel.layer.masksToBounds = true
        self.chatLabel.layer.cornerRadius = 5.0
        self.chatLabel.isHidden = true
        
        self.manAPI()
    }
    //使⽤者資料
    func manAPI() {
    
    ServerAPIManager.sharedInstance.manAPI(onSuccess: { (response) in
        
        self.mandata =  response.value(forKey: "response") as? NSArray ?? []
        let value = self.mandata[0] as? NSDictionary ?? [:]
        self.nameBtn.setTitle((value.value(forKey: "name") as? String ?? ""), for: .normal)
        self.kokoId.setTitle("設定KOKO ID :\(value.value(forKey: "kokoid") as? String ?? "")", for: .normal)
        if value.count > 0 {
            
            self.kokoidConstrait.constant = 180
        }else{
            self.kokoidConstrait.constant = 120
        }
        self.friend4API()
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    //無好友畫⾯：request API 2-(5)
    func friend4API() {
    
    ServerAPIManager.sharedInstance.friend4API(onSuccess: { (response) in
        
        self.friend4data =  response.value(forKey: "response") as? NSArray ?? []
        print("friend4data",self.friend4data)
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    
    @IBAction func back(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
