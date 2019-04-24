//
//  CardNewsTableViewCell.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class CardNewsTableViewCell: UITableViewCell {

    var titleText: String? {
        didSet {
            guard let title = titleText else { return }
            titleLabel.text = title
        }
    }
    
    var mainText: String? {
        didSet {
            guard let content = mainText else { return }
            mainLabel.text = content
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
