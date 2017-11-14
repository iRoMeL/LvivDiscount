//
//  BarcodeReaderViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 10.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class BarcodeReaderViewController: RSCodeReaderViewController {
	
	var delegate:SetBarcodeDelegate!
	
	private var barcode: String = ""
	private var barcodeType: String = ""
	private var dispatched: Bool = false
	private let gen = RSUnifiedCodeGenerator.shared
	

	@IBAction func close(_ sender: AnyObject?) {
		print("close called.")
		dismiss(animated: true, completion: nil)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.focusMarkLayer.strokeColor = UIColor.red.cgColor
		self.cornersLayer.strokeColor = UIColor.yellow.cgColor
		
		self.tapHandler = { point in
			print(point)
		}
		
		self.barcodesHandler = { barcodes in
			if !self.dispatched { // triggers for only once
				self.dispatched = true
				for barcode in barcodes {
					
					self.barcode = barcode.stringValue!
					self.barcodeType = barcode.type.rawValue
					
					print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcode.stringValue!)
					
					DispatchQueue.main.async(execute: {
						
						if !self.barcode.isEmpty {
							
							
							self.delegate.setBarcode(withNumber: self.barcode, andType: self.barcodeType)
							self.dismiss(animated: true, completion: nil)
						}
					})
					
					break
				}
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let navigationController = self.navigationController {
			navigationController.isNavigationBarHidden = true
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let navigationController = self.navigationController {
			navigationController.isNavigationBarHidden = false
		}
		
		
	}
	
	
}
