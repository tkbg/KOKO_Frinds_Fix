//
//  ViewController.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/9.
//
import UIKit
import Foundation

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var Middleconstraint: NSLayoutConstraint!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var kokoId: UIButton!
    @IBOutlet weak var kokoidConstrait: NSLayoutConstraint!
    
    var viewModel: UserViewModel!
    private var refreshControl: UIRefreshControl?
    
    var mandata:NSArray = []
    var friend1data:NSArray = []
    var friend2data:NSArray = []
    var newfriend1data:NSMutableArray = []
    var newfriend2data:NSMutableArray = []
    var friend1_2data:NSMutableArray = [NSMutableDictionary()]
    
    var cellArray:NSMutableArray = [NSMutableDictionary()]
        
    @IBOutlet weak var middenTableView: UITableView!
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var seachBtn: UISearchBar!
    
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    // MARK: - tableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cellArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let value1 = self.cellArray[indexPath.row] as? NSDictionary ?? [:]
        let user = User(kokoid: value1.value(forKey: "kokoid") as? String ?? "" , name: value1.value(forKey: "name") as? String ?? "", isTop: value1.value(forKey: "isTop") as? String ?? "" , status: value1.value(forKey: "status") as? Int ?? 0)
        
        print("user",user)
        
        self.viewModel = UserViewModel(user: user)
        
        guard let  tableCell = tableView.dequeueReusableCell(withIdentifier:"tableCell", for: indexPath) as? tableCell else {return UITableViewCell()}
        
        if let viewModel = viewModel {
            
            if viewModel.isTop == "0" {
                
                tableCell.star.isHidden = true
            }else{
                tableCell.star.isHidden = false
            }
            tableCell.name1.text = viewModel.name
            
            tableCell.TransferBtn.layer.masksToBounds = true
            tableCell.TransferBtn.layer.borderWidth = 1
            tableCell.TransferBtn.layer.borderColor = UIColor(red: 236.0/255, green: 0.0/255, blue: 140.0/255, alpha: 1.0).cgColor
            
            if viewModel.status == 2 {
                tableCell.status.layer.masksToBounds = true
                tableCell.status.layer.borderWidth = 1
                tableCell.status.layer.borderColor = UIColor.lightGray.cgColor
                tableCell.status.setTitle("邀請中", for: .normal)
                tableCell.status.setImage(nil, for: .normal)
            }else{
                tableCell.TransferBtn.layer.masksToBounds = false
                tableCell.status.layer.borderWidth = 0
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

            // 獲取搜尋框中的文字
            let searchText = searchBar.text ?? ""
            print("searchText",searchText)
            
            // 收起鍵盤
            searchBar.resignFirstResponder()
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       
        self.Middleconstraint.constant = 143.0
        self.friendView.isHidden = false
        self.chatView.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // 下拉更新
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.controlRefrsh(_:)), for: .valueChanged)
       
        if let refreshControl = self.refreshControl {
           
            self.middenTableView.addSubview(refreshControl)
        }
        
        //設定圓角
        self.friendLabel.layer.masksToBounds = true
        self.friendLabel.layer.cornerRadius = self.friendLabel.frame.height/2
        self.friendLabel.isHidden = true
        
        //設定圓角
        self.chatLabel.layer.masksToBounds = true
        self.chatLabel.layer.cornerRadius = 5.0
        self.chatLabel.isHidden = true

        //seachBtn.delegate
        self.seachBtn.delegate = self
        self.seachBtn.placeholder = NSLocalizedString("想轉一筆給誰呢？", comment: "")
                
        self.middenTableView.delegate = self
        self.middenTableView.dataSource = self
        
        self.middenTableView.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        
        self.manAPI()
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
        
        self.cellArray.removeAllObjects()
        self.friend1API()
        
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
            
            var mutableArray:NSMutableArray = [NSMutableDictionary()]

            
            mutableArray = self.friend1_2data
            
            print("mutableArray:",mutableArray)
            
            //同時request兩個資料，將兩個資料源整合為列表，若重覆fid資料則取updateDate較新的那⼀筆
            let swiftArray = mutableArray.compactMap { $0 as? [String: Any] }

            let filteredArray = swiftArray.reduce(into: [[String: Any]]()) { (result, current) in
                if let existingIndex = result.firstIndex(where: { ($0["name"] as? String) == (current["name"] as? String) }) {
                    
                    if let existingUpdateDate = result[existingIndex]["updateDate"] as? Int,
                       let currentUpdateDate = current["updateDate"] as? Int {
                        if currentUpdateDate > existingUpdateDate {
                            
                            result[existingIndex] = current
                        }
                    }
                } else {
                    
                    result.append(current)
                }
            }
            self.cellArray = NSMutableArray(array: filteredArray)

            print("self.cellArray:",self.cellArray)
            
            let f_Array = self.cellArray.filter { ($0 as! NSDictionary).value(forKey: "status") as? Int == 2 }

            print("f_Array,",f_Array)
            
            let labelString:String = "\(f_Array.count)"
            
            //設定好友數量status = 2
            self.friendLabel.text = NSLocalizedString(labelString, comment: "")
            
            
            if self.cellArray.count > 0 {
                
                self.chatLabel.isHidden = false
                self.friendLabel.isHidden = false
            }else{
                self.chatLabel.isHidden = true
                self.friendLabel.isHidden = true
            }
        self.refreshControl?.endRefreshing()
        self.middenTableView.reloadData()
                
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    @objc func controlRefrsh(_ sender: Any?) {
        
        self.cellArray.removeAllObjects()
        self.friend1API()
  
    }
    @IBAction func back(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
}

    
