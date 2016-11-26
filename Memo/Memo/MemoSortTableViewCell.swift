//
//  MemoSortTableViewCell.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class MemoSortTableViewCell: UITableViewCell {

    @IBOutlet weak var memoPhoto: UIImageView!
    @IBOutlet weak var memoTime: UILabel!
    @IBOutlet weak var memoContent: UILabel!
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
