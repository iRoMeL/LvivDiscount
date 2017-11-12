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
			
			
			//print(imageToRotate.imageOrientation.rawValue)
			
			let aaa = fixOrientation(img: imageToRotate).rotate(degrees: 90)
			contentImageView.image = aaa
			//print(aaa?.imageOrientation.rawValue)
			//contentImageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(M_PI)) / 180.0)
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	func fixOrientation(img:UIImage) -> UIImage {
		
		if (img.imageOrientation == UIImageOrientation.up) {
			return img;
		}
		
		UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
		let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
		img.draw(in: rect)
		
		let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext();
		return normalizedImage;
		
	}
	
}
