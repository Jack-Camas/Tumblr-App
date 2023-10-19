//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Jack Camas on 10/17/23.
//

import UIKit

class PostCell: UITableViewCell {
	
	@IBOutlet weak var postImageView: UIImageView!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var cardView: UIView!
	@IBOutlet weak var containerView: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
		
		containerView.layer.cornerRadius = 10
		containerView.layer.shadowColor = UIColor.gray.cgColor
		containerView.layer.shadowOpacity = 1.0
		containerView.layer.shadowRadius = 1
		containerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
		containerView.backgroundColor = .white
		
		cardView.layer.masksToBounds = true
		cardView.layer.cornerRadius = 10
		
		summaryLabel.numberOfLines = 0

    }
}
