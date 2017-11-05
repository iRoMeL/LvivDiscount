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
	
	// MARK: - Properties
	
	var index = 0
	var imageFile = ""
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		
		getImage(name: imageFile)
		//contentImageView.image = UIImage(named: imageFile)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		//
		
	}
	
	func getDirectoryPath() -> String {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}

	
	func getImage(name: String){
		let fileManager = FileManager.default
		let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(name)
		if fileManager.fileExists(atPath: imagePAth){
			
			
			
			contentImageView.image = UIImage(contentsOfFile: imagePAth)
			//contentImageView.transform = contentImageView.transform.rotated(by: CGFloat(Double.pi/2))
		}else{
			print("No Image")
		}
	}
	
}
