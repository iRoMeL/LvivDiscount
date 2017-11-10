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

		
    }
	
	
	func configureCell(with card: CardMO)  {
		
		
		 //DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
			
		if let imageCell = FileManagerHelper.instance.getImageFromDisk(withName: card.frontimage!) {
				self.imagecell.image = resizeImage(image: imageCell, newWidth: CGFloat(320))
			}
		//}
		
		
		self.name.text			= card.name ?? ""
		//self.summary.numberOfLines = 0
		self.summary.text		= card.summary ?? ""
		
		
		
	}
	


}
