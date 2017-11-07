//
//  CardContentViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 05.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

extension UIImage {
	struct RotationOptions: OptionSet {
		let rawValue: Int
		
		static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
		static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
	}
	
	func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }
		
		let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
		let transform = CGAffineTransform(rotationAngle: rotationInRadians)
		var rect = CGRect(origin: .zero, size: self.size).applying(transform)
		rect.origin = .zero
		
		let renderer = UIGraphicsImageRenderer(size: rect.size)
		return renderer.image { renderContext in
			renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
			renderContext.cgContext.rotate(by: rotationInRadians)
			
			let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
			let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
			renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
			
			let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
			renderContext.cgContext.draw(cgImage, in: drawRect)
		}
	}
}

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
			
			
			let imageRotated = UIImage(contentsOfFile: imagePAth)?.rotated(by: Measurement(value: 180.0, unit: .degrees))
			contentImageView.image = imageRotated
			//contentImageView.transform = contentImageView.transform.rotated(by: CGFloat(Double.pi/2))
		}else{
			print("No Image")
		}
	}
	
}
