//
//  BarcodeReaderViewController.swift
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 6/10/14.
//
//  Updated by Jarvie8176 on 01/21/2016
//
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class BarcodeReaderViewController: RSCodeReaderViewController {
    
    @IBOutlet var toggle: UIButton!
	
	var delegate:NewCardViewController!
	
	var barcode: String = ""
	var dispatched: Bool = false
	
    @IBAction func switchCamera(_ sender: AnyObject?) {
		
    }
    
    @IBAction func close(_ sender: AnyObject?) {
        print("close called.")
    }
    
    @IBAction func toggle(_ sender: AnyObject?) {
		
    }
    
   // var barcode: String = ""
   // var dispatched: Bool = false
    
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
					print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcode.stringValue!)
					
					DispatchQueue.main.async(execute: {
					//	self.performSegue(withIdentifier: "nextView", sender: self)
						if !self.barcode.isEmpty {
							self.delegate.barcodeTextField.text = self.barcode
							self.dismiss(animated: true, completion: nil)
						}
						//self.navigationController?.popToRootViewController(animated: true)
						// MARK: NOTE: Perform UI related actions here.
					})
					
					// MARK: NOTE: break here to only handle the first barcode object
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
		
		if !self.barcode.isEmpty {
			self.delegate.barcodeTextField.text = self.barcode
			
			//segue.identifier == "nextView" &&
			//if let destinationVC = segue.destination as? NewCardViewController {
			//	destinationVC.barcodeTextField.text = self.barcode
			//}
		}
	}

        

    
}
