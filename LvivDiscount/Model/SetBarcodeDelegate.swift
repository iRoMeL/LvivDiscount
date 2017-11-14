//
//  ScanBarcodeDelegate.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 12.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import Foundation
protocol SetBarcodeDelegate {
	
	func setBarcode(withNumber number : String, andType type: String)
	
}
