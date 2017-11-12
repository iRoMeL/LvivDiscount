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
			
			//contentImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2));
			//let abc = imageToRotate.rotate(degrees: 90)
			contentImageView.image = imageToRotate
			
			
			contentImageView.image = imageToRotate.rotate(degrees: 90)
			print(imageToRotate.imageOrientation.rawValue)
			//contentImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
}
