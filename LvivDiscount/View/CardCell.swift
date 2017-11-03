//
//  CardCell.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

	@IBOutlet weak var imagecell: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var summary: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func configureCell(withcard card:CardMO)  {
		
		//kingfisher
		//let imageUrl = card.imageUrl
		
		//if  imageUrl.isEmpty {
			
		//	self.imagecell.kf.base.image = #imageLiteral(resourceName: "placeholder.png")
			
		//} else {
		//	let url = URL(string: imageUrl)!
		//	self.imagecell.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder.png"))
		//}
		
		
		self.name.text			= card.name ?? ""
		self.summary.text		= card.summary ?? ""
		
		
		
	}


}
