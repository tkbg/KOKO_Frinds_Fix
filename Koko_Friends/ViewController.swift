//
//  ViewController.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/9.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var Middleconstraint: NSLayoutConstraint!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var kokoId: UIButton!
    @IBOutlet weak var kokoidConstrait: NSLayoutConstraint!
    var viewModel: UserViewModel!
    private var refreshControl: UIRefreshControl?
    var mandata:NSArray = []
    var friend1data:NSArray = []
    var friend2data:NSArray = []
    var friend3data:NSArray = []
    var newfriend1data:NSMutableArray = []
    var newfriend2data:NSMutableArray = []
    var friend1_2data:NSMutableArray = [NSMutableDictionary()]
    @IBOutlet weak var middenTableView: UITableView!
    @IBOutlet weak var tableBgView: UIView!
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var addFriend: UIButton!
    @IBOutlet weak var addFriend2: UIButton!
    @IBOutlet weak var seachBtn: UISearchBar!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    // MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friend1_2data.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let  tableCell = tableView.dequeueReusableCell(withIdentifier:"tableCell", for: indexPath) as? tableCell else {return UITableViewCell()}
        let value1 = self.friend1_2data[indexPath.row] as? NSDictionary ?? [:]
//        print("friend1_2data",self.friend1_2data)
        print("value1",value1.value(forKey: "name") as? String ?? "")
        print("value1",value1.value(forKey: "status") as? Int ?? 0)
        let user = User(kokoid: value1.value(forKey: "kokoid") as? String ?? "" , name: value1.value(forKey: "name") as? String ?? "", isTop: value1.value(forKey: "isTop") as? String ?? "" , status: value1.value(forKey: "status") as? Int ?? 0)
        print("user",user)
        self.viewModel = UserViewModel(user: user)
        
        if let viewModel = viewModel {
            
            if viewModel.isTop == "0" {
                
                tableCell.star.isHidden = true
            }else{
                tableCell.star.isHidden = false
            }
            tableCell.name1.text = viewModel.name
            
            if viewModel.status == 2 {
                
                tableCell.status.setTitle("邀請中", for: .normal)
                tableCell.status.setImage(nil, for: .normal)
//                tableCell.status.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                tableCell.status.setTitle("", for: .normal)
                tableCell.status.setImage(UIImage(named: "icFriendsMore.png"), for: .normal)
                tableCell.status.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
              
        return tableCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    // MARK: - SearchBar Delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            // 點擊搜尋框時觸發的事件
            
            self.Middleconstraint.constant = 0
            self.friendView.isHidden = true
            self.chatView.isHidden = true
        
            return true // 返回 true 允許開始編輯
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // 按下 Enter 鍵時觸發的事件

            // 獲取搜尋框中的文字
            let searchText = searchBar.text ?? ""

            // 執行搜尋操作
            // ...
            
            // 收起鍵盤
            searchBar.resignFirstResponder()
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("textDidChange",searchText)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       
        print("searchBarTextDidEndEditing")
        self.Middleconstraint.constant = 143.0
        self.friendView.isHidden = false
        self.chatView.isHidden = false
        
//        self.seachBtn.resignFirstResponder()
//        willFormtableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("shouldChangeTextIn,range, replacementText",range, text)
//        if range.location < 31 {
//            
//            if AlertMannger.shared.checkSearchText(toSqlInjection: text) == true {
//                
//                return true
//            } else {
//
        
//                searchBar.resignFirstResponder()
                
                return true
//            }
//        }
//        return false
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.controlRefrsh(_:)), for: .valueChanged)
       
        if let refreshControl = self.refreshControl {
           
            self.middenTableView.addSubview(refreshControl)
        }
        self.friendLabel.text = NSLocalizedString("2", comment: "")
        
        self.friendLabel.layer.masksToBounds = true
        self.friendLabel.layer.cornerRadius = self.friendLabel.frame.height/2
        self.friendLabel.isHidden = true
        
        self.chatLabel.layer.masksToBounds = true
        self.chatLabel.layer.cornerRadius = 5.0
        self.chatLabel.isHidden = true
        
        self.addFriend.layer.masksToBounds = true
        self.addFriend.layer.cornerRadius = 25.0
        
        self.addFriend2.layer.masksToBounds = true
        self.addFriend2.layer.cornerRadius = 25.0

        self.seachBtn.delegate = self
        self.seachBtn.placeholder = NSLocalizedString("想轉一筆給誰呢？", comment: "")
        
        self.addFriend.setTitle("只有好友列表", for: .normal)
        
        tableBgView.isHidden = true
        middenTableView.delegate = self
        middenTableView.dataSource = self
        self.middenTableView.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        
        manAPI()
    }
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
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    func friend1API() {
    
    ServerAPIManager.sharedInstance.friend1API(onSuccess: { (response) in
        
        self.friend1data =  response.value(forKey: "response") as? NSArray ?? []
        
        self.newfriend1data = [NSMutableDictionary()]
        for index in 0 ..< self.friend1data.count {
            
            let dict1 = self.friend1data[index] as? NSDictionary ?? [:]
            let updateDate = dict1.value(forKey: "updateDate") as? String ?? ""
            let newDateString = updateDate.replacingOccurrences(of: "/", with: "")
            var newDict:NSMutableDictionary = [:]
            newDict = dict1.mutableCopy() as! NSMutableDictionary
            newDict.setValue(newDateString, forKey: "updateDate")
            self.newfriend1data.add(newDict)
                
        }
        self.friend2API()
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    func friend2API() {
    
        ServerAPIManager.sharedInstance.friend2API(onSuccess: { (response) in
            
            self.friend2data =  response.value(forKey: "response") as? NSArray ?? []
            
            self.newfriend2data = [NSMutableDictionary()]
            for index in 0 ..< self.friend2data.count {
                
                let dict2 = self.friend2data[index] as? NSDictionary ?? [:]
                let updateDate = dict2.value(forKey: "updateDate") as? String ?? ""
                let newDateString = updateDate.replacingOccurrences(of: "/", with: "")
                var newDict:NSMutableDictionary = [:]
                newDict = dict2.mutableCopy() as! NSMutableDictionary
                newDict.setValue(newDateString, forKey: "updateDate")
                self.newfriend2data.add(newDict)
                
            }
            for index in 0 ..< self.newfriend1data.count {
                
                let dict3 = self.newfriend1data[index] as? NSDictionary ?? [:]
                
                var newDict:NSMutableDictionary = [:]
                newDict = dict3.mutableCopy() as? NSMutableDictionary ?? [:]
                if newDict.count > 0 {
                    self.friend1_2data.add(newDict)
                }
                
            }
            for index in 0 ..< self.newfriend2data.count {
                
                let dict4 = self.newfriend2data[index] as? NSDictionary ?? [:]
                
                var newDict:NSMutableDictionary = [:]
                newDict = dict4.mutableCopy() as? NSMutableDictionary ?? [:]
                if newDict.count > 0 {
                    self.friend1_2data.add(newDict)
                }
                
            }
            self.friend1_2data.remove([:])
            if self.friend1_2data.count > 0 {
                self.chatLabel.isHidden = false
                self.friendLabel.isHidden = false
            }else{
                self.chatLabel.isHidden = true
                self.chatLabel.isHidden = true
            }
        
        
        self.refreshControl?.endRefreshing()
        self.middenTableView.reloadData()
                
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    
    func friend3API() {
    
    ServerAPIManager.sharedInstance.friend3API(onSuccess: { (response) in
        
        self.friend3data =  response.value(forKey: "response") as? NSArray ?? []
        print("friend3data",self.friend3data)
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    
    @IBAction func addFriendBtn(_ sender: Any) {
        
        self.friend1API()
        tableBgView.isHidden = false
    }
    
    @IBAction func addFriend2Btn(_ sender: Any) {
        
//        self.friend1_2data.removeAllObjects()
        print("addFriend2Btn")
        self.friend3API()
        
    }
    @objc func controlRefrsh(_ sender: Any?) {
        
        self.friend1_2data.removeAllObjects()
        self.manAPI()
    }
}

    
