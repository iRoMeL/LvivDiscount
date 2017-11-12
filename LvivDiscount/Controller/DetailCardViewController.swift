//
//  DetailCardViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 05.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

class DetailCardViewController: UIViewController, CardPageViewControllerDelegate {
	
	
	var cardPVC: CardPVC?
    var card:CardMO!
	
	@IBOutlet var pageControl: UIPageControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destination = segue.destination
		if let pageViewController = destination as? CardPVC {
			cardPVC = pageViewController
			cardPVC?.cardDelegate = self
			
			var pageimages:[String] = []
			
			if card.frontimage != nil {
				pageimages.append(card.frontimage!)
			}
			if card.backtimage != nil {
				pageimages.append(card.backtimage!)
			}
			if card.barcodeimage != nil {
				pageimages.append(card.barcodeimage!)
			}
			
			
			cardPVC?.pageImages = pageimages
			pageControl.numberOfPages = pageimages.count
		}
	}
	
	func didUpdatePageIndex(currentIndex: Int) {
		if let index = cardPVC?.currentIndex {
			
			pageControl.currentPage = index
		}
	}
	
}
