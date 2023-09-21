//
//  LectureTableViewCell.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/19.
//

import UIKit

class LectureTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(day: String){
        dayLabel.text = day
    }
}
