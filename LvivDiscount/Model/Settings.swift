//
//  Settings.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 16.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import Foundation

public var showDetailView:Bool {
	
	get {
		if let sdv = UserDefaults.standard.object(forKey: "showDetailView") as? Bool {
			return sdv
		} else{
			UserDefaults.standard.set(true, forKey: "showDetailView")
			return true
		}
	}
	
	set{
		if newValue == true {
			UserDefaults.standard.set(true, forKey: "showDetailView")
		} else{
			UserDefaults.standard.set(false, forKey: "showDetailView")
		}
	}
}
