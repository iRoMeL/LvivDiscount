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
		
		
		let fileManager = FileManager.default
		
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

		let imagePAth = (paths as NSString).appendingPathComponent(card.frontimage!)
		if fileManager.fileExists(atPath: imagePAth){
			self.imagecell.image = UIImage(contentsOfFile: imagePAth)
		}else{
			print("No Image")
		}
		
		self.name.text			= card.name ?? ""
		self.summary.text		= card.summary ?? ""
		
		
		
	}
	


}
