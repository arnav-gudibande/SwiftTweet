//
//  HashtagTrendingTableViewCell.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/15/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit

class HashtagTrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetVolume: UILabel!
    @IBOutlet weak var trendingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
