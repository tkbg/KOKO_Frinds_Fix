//
//  File.swift
//  Koko_Friends
//
//  Created by HowardHung on 2024/12/16.
//

import Foundation
import UIKit

class inviteCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cellBgView: UIView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        cellBgView.layer.masksToBounds = true
        cellBgView.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
