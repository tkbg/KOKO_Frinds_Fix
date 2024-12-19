//
//  ViewController.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/9.
//

import UIKit
import Foundation

struct CellData {
    var isExpanded: Bool
    var content: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var Middleconstraint: NSLayoutConstraint!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var kokoId: UIButton!
    @IBOutlet weak var kokoidConstrait: NSLayoutConstraint!
    
    var viewModel: UserViewModel!
    
    private var refreshControl: UIRefreshControl?
    
    var mandata:NSArray = []
    var friend3data:NSArray = []
    
    var status_0:NSMutableArray = []
    var status_2:NSMutableArray = []
    var cellDataArray:[CellData] = []
    
    var isExpanded: Bool = false
    
    @IBOutlet weak var middenTableView: UITableView!
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var seachBtn: UISearchBar!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteTv: UITableView!
    
    // MARK: - tableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView.tag == 2 {
            
            return 1
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 2 {
            
            return self.status_2.count
        }else {
            
            var count: Int = 0
            
            if self.isExpanded == true {
                
                count = self.cellDataArray.count
            } else {
                
                count = self.cellDataArray.count > 0 ? 1 : 0
            }
            
            return count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 2 {
            
            let value1 = self.status_2[indexPath.row] as? NSDictionary ?? [:]
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
        }else {
            
            guard let  inviteCell = tableView.dequeueReusableCell(withIdentifier:"inviteCell", for: indexPath) as? inviteCell else {return UITableViewCell()}
            
            let cellData = cellDataArray[indexPath.row]
            inviteCell.name.text = cellData.content
            
                if cellData.isExpanded {
                    inviteCell.name.numberOfLines = 0
                } else {
                    inviteCell.name.numberOfLines = 1
                }
            
            inviteCell.alpha = 0 // 初始設為透明

                // 動畫淡入
                UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: .curveEaseIn, animations: {
                    inviteCell.alpha = 1
                }, completion: nil)
            return inviteCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.tag == 1 {
            
//            self.isExpanded.toggle()
            self.isExpanded = !self.isExpanded
            
//            self.cellDataArray[indexPath.row].isExpanded = !cellDataArray[indexPath.row].isExpanded
//            self.inviteTv.reloadRows(at: [indexPath], with: .automatic)
//            self.inviteTv.reloadData()
//            UIView.animate(withDuration: 0.3, animations: {
////                self.inviteTv.reloadSections(IndexSet(integer: 0), with: .automatic)
//                self.inviteTv.reloadData()
//                    })
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05) // 放大 5%
            }) { _ in
                
                UIView.animate(withDuration: 0.3) {
                    
                    cell.transform = .identity // 恢復原始大小
                    
                    if self.isExpanded {
                        
                        let insertIndexPath = IndexPath(row: indexPath.row, section: 0)
                        tableView.insertRows(at: [insertIndexPath], with: .top) // 加入動畫
                    } else {
                        
                        tableView.deleteRows(at: [indexPath], with: .bottom) // 加入動畫
                    }
                    
                    self.inviteTv.reloadData()
                }
            }
        }
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
       
        self.Middleconstraint.constant = 250.0
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
        //下拉更新
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
    
        self.seachBtn.delegate = self
        self.seachBtn.placeholder = NSLocalizedString("想轉一筆給誰呢？", comment: "")
        self.middenTableView.delegate = self
        self.middenTableView.dataSource = self
        self.inviteTv.delegate = self
        self.inviteTv.dataSource = self
        
        self.middenTableView.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        self.inviteTv.register(UINib(nibName: "inviteCell", bundle: nil), forCellReuseIdentifier: "inviteCell")
        
        self.inviteTv.estimatedRowHeight = 44 // 設定一個估計值
        self.inviteTv.rowHeight = UITableView.automaticDimension //
        
        self.manAPI()
        self.friend3API()
        self.Middleconstraint.constant = 250.0
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
    func friend3API() {
        
        self.status_0.removeAllObjects()
        self.status_2.removeAllObjects()
        self.cellDataArray.removeAll()
    
    ServerAPIManager.sharedInstance.friend3API(onSuccess: { (response) in
        
        var mutableArray:NSMutableArray = [NSMutableDictionary()]
        
        self.friend3data =  response.value(forKey: "response") as? NSArray ?? []
        print("friend3data",self.friend3data)
        
        mutableArray = self.friend3data.mutableCopy() as! NSMutableArray
        
        if mutableArray.count > 0 {
            self.chatLabel.isHidden = false
            self.friendLabel.isHidden = false
        }else{
            self.chatLabel.isHidden = true
            self.friendLabel.isHidden = true
        }
        print("mutableArray",mutableArray)
        
//        let f_Array = mutableArray.filter { ($0 as! NSDictionary).value(forKey: "status") as? Int == 2 }
//
//        print("f_Array,",f_Array)
        
        for index in 0 ..< mutableArray.count {
            
            let dict = mutableArray[index] as? NSDictionary ?? [:]
            
            var newDict:NSMutableDictionary = [:]
            newDict = dict.mutableCopy() as? NSMutableDictionary ?? [:]
            if newDict.count > 0 {
                
                if newDict.value(forKey: "status") as? Int == 0 {
                    
                    self.status_0.add(newDict)
                }else{
                    self.status_2.add(newDict)
                }
            }
            
        }
        print("status_0",self.status_0)
        print("status_2",self.status_2)
        
        let f_Array = self.status_2.filter { ($0 as! NSDictionary).value(forKey: "status") as? Int == 2 }

        let labelString:String = "\(f_Array.count)"
        
        //設定好友數量status = 2
        self.friendLabel.text = NSLocalizedString(labelString, comment: "")

        
        self.cellDataArray = self.status_0.map { CellData(isExpanded: false, content: ($0 as! NSDictionary).value(forKey: "name") as? String ?? "") }
        print("self.cellDataArray,",self.cellDataArray)
        self.inviteView.isHidden = false
        self.refreshControl?.endRefreshing()
        self.middenTableView.reloadData()
        self.inviteTv.reloadData()
        
    }, onFailure: { errorDict in
        
        if let msg = errorDict["errorMsg"] {
            
            print("failure, \(msg)")
        }
    })
}
    @objc func controlRefrsh(_ sender: Any?) {
                
        self.friend3API()
        self.Middleconstraint.constant = 250.0
    }
    @IBAction func back(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
}

    
