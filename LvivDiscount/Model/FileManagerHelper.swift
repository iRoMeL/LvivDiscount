//
//  FileManagerHelper.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 07.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import Foundation
import UIKit

class FileManagerHelper {
	
	static let instance 	= FileManagerHelper()
	private let fileManager = FileManager.default
	private let paths 		= NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

	
	func getImageFromDisk(withName name : String) -> UIImage? {
		
		let imagePath = (paths as NSString).appendingPathComponent(name)
		if fileManager.fileExists(atPath: imagePath){
			return UIImage(contentsOfFile: imagePath)
		} else {
			return nil
		}
		
	}
	
	
	func saveImageToDisk(image : UIImage, withName name : String){
		let imagePath = (paths as NSString).appendingPathComponent(name)
		let imageData = UIImageJPEGRepresentation(image, 0.5)
		fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
	}

	
	func deleteImageFromDisk(withName name : String) {
		
		let imagePath = (paths as NSString).appendingPathComponent(name)
		if fileManager.fileExists(atPath: imagePath){
			do {
				try fileManager.removeItem(atPath: imagePath)
				print("Deleting file \(imagePath)")
			}
			catch let error as NSError {
				print("Ooops! Something went wrong: \(error)")
			}
			
		}
	}
	

	
}
