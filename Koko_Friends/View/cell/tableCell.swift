//
//  tableCell.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/11.
//

import UIKit

class tableCell: UITableViewCell {
    
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var name1: UILabel!
    
    @IBOutlet weak var TransferBtn: UIButton!
    @IBOutlet weak var status: UIButton!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

