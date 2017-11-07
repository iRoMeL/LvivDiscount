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
	
	private let fileManager = FileManager.default
	private let paths 		= NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
	
	
	func getImageFromDisk(withName name : String) -> UIImage? {
		
		let imagePAth = (paths as NSString).appendingPathComponent(name)
		if fileManager.fileExists(atPath: imagePAth){
			return UIImage(contentsOfFile: imagePAth)
		} else {
			return nil
		}
		
	}
	
	func saveImageToDisk() -> Bool {
		return true
	}
	

	
}
