//
//  CardContentViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 05.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

class CardContentViewController: UIViewController {
	
	@IBOutlet var contentImageView: UIImageView!
	
	
	var index = 0
	var imageFile = ""
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		

		if let imageToRotate = FileManagerHelper.instance.getImageFromDisk(withName: imageFile) {
			contentImageView.image = imageToRotate.rotate(degrees: CGFloat(-90))
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
}
