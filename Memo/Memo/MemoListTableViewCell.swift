//
//  MemoListTableViewCell.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alongImageView: UIImageView!
    @IBOutlet weak var memoContent: UILabel!
    @IBOutlet weak var memoTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
