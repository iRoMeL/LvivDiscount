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
		
		
		
		// Do any additional setup after loading the view.
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
			cardPVC?.pageImages = [card.frontimage!, card.backtimage!,card.backtimage!]
		}
	}
	
	func didUpdatePageIndex(currentIndex: Int) {
		if let index = cardPVC?.currentIndex {
			
			pageControl.currentPage = index
		}
	}
	
}
