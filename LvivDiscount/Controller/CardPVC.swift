//
//  CardPVC.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 05.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

protocol CardPageViewControllerDelegate: class {
	func didUpdatePageIndex(currentIndex: Int)
}

class CardPVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	
	var pageImages:[String] = []
	
	var currentIndex = 0
	
	weak var cardDelegate: CardPageViewControllerDelegate?
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		var index = (viewController as! CardContentViewController).index
		index -= 1
		
		return contentViewController(at: index)
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		var index = (viewController as! CardContentViewController).index
		index += 1
		
		return contentViewController(at: index)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		if completed {
			if let contentViewController = pageViewController.viewControllers?.first as? CardContentViewController {
				print("Content view controller index: \(contentViewController.index)")
				
				currentIndex = contentViewController.index
				
				cardDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
			}
			
		}
	}

	



override func viewDidLoad() {
	super.viewDidLoad()
	
	// Set the data source and delegate to itself
	dataSource = self
	delegate = self
	
	// Create the first screen
	if let startingViewController = contentViewController(at: 0) {
		setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
	}
	
}

override func didReceiveMemoryWarning() {
	super.didReceiveMemoryWarning()
	// Dispose of any resources that can be recreated.
}

func contentViewController(at index: Int) -> CardContentViewController? {
	if index < 0 || index >= 3 {
		return nil
	}
	
	// Create a new view controller and pass suitable data.
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "CardContentViewController") as? CardContentViewController {
		
		pageContentViewController.imageFile = pageImages[index]
		pageContentViewController.index = index
		
		return pageContentViewController
	}
	
	return nil
}

}
