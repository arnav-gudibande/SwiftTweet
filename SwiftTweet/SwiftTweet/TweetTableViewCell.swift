//
//  TweetTableViewCell.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/8/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var TweetFullName: UILabel!
    @IBOutlet weak var TweetUserName: UILabel!
    @IBOutlet weak var TweetProfilePic: UIImageView!
    @IBOutlet weak var TweetBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
