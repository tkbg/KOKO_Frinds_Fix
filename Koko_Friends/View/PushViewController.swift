//
//  PushViewController.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/17.
//

import UIKit
import Foundation

class PushViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pushToAddFriend(_ sender: UIButton) {
        
        let addvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        addvc.modalPresentationStyle = .fullScreen
        self.present(addvc, animated: false, completion: nil)
    }
    
    @IBAction func pushToOnlyFriend(_ sender: UIButton) {
        
        let friendvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendViewController") as! FriendViewController
        friendvc.modalPresentationStyle = .fullScreen
        self.present(friendvc, animated: false, completion: nil)
    }
    
    @IBAction func pushButton(_ sender: Any) {
        
//        self.performSegue(withIdentifier: "pushToNext", sender: nil)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)

    }
    //MARK: - 傳值至下頁
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               
            if segue.identifier ==  "pushToNext"{
                
                let controller = segue.destination as? ViewController
                controller?.navigationItem.title = "下一頁"
                
            }
        }

}
