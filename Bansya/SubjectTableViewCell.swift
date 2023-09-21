//
//  SubjectTableViewCell.swift
//  Bansya
//
//  Created by 三木　杏夏 on 2023/09/18.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(title: String, day: String){
        titleLabel.text = title
        dayLabel.text = day
    }
}
