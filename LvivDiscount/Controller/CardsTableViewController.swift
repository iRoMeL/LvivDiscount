//
//  CardsTableViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData
import Persei

class CardsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
	
	
	private var cards:[CardMO] = []
	private var searchResults: [CardMO] = []
	
	private var fetchResultController: NSFetchedResultsController<CardMO>!
	private var searchController: UISearchController!
	
	@IBAction func unwindToHome(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let menu = MenuView()
		
		//let items = feedModes.map { mode: SomeYourCustomFeedMode -> MenuItem in
		//	return MenuItem(image: mode.image)
		//}
		
		//menu.items = items
		tableView.addSubview(menu)
		
		tableView.cellLayoutMarginsFollowReadableWidth = true
		//navigationController?.navigationBar.prefersLargeTitles = true

		//Theme
		tableView.separatorColor = Theme.Colors.LightTextColor.color
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color

		//tableView.estimatedRowHeight = 120
		//tableView.rowHeight = UITableViewAutomaticDimension
		
		//кнопка  Sort
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sorting"), style: .plain, target: self, action: #selector(showSortActionSheet))

		
		//при початковому завантажені приховуємо пошук
		let offset = CGPoint(x: 0, y: 44)
		tableView.setContentOffset(offset, animated: true)

		// Adding a search bar
		searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = NSLocalizedString("Search cards...", comment: "Search cards...")
		//searchController.searchBar.barTintColor = .white
		//searchController.searchBar.backgroundImage = UIImage()
		
		searchController.searchBar.barTintColor				= Theme.Colors.BackgroundColor.color
		searchController.searchBar.tintColor				= Theme.Colors.TintColor.color
		searchController.searchBar.enablesReturnKeyAutomatically = true
		searchController.searchBar.keyboardAppearance		= .dark

		if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
			textFieldInsideSearchBar.textColor = Theme.Colors.TintColor.color
			textFieldInsideSearchBar.borderStyle = .roundedRect
			textFieldInsideSearchBar.backgroundColor = Theme.Colors.BackgroundColor.color
		}

		
		definesPresentationContext = true
		
		if #available(iOS 11.0, *) {
			self.navigationItem.searchController = searchController
			searchController.isActive = true
		}else {
			tableView.tableHeaderView = searchController.searchBar
		}
		
		
		// Fetch data from data store
		let fetchRequest: NSFetchRequest<CardMO> = CardMO.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
			let context = appDelegate.persistentContainer.viewContext
			fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
			fetchResultController.delegate = self
			
			do {
				try fetchResultController.performFetch()
				if let fetchedObjects = fetchResultController.fetchedObjects {
					cards = fetchedObjects
				}
			} catch {
				print(error)
			}
		}
		
		tableView.tableFooterView = UIView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchController.isActive {
			return searchResults.count
		} else {
			return cards.count
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell {
			
			let card = (searchController.isActive) ? searchResults[indexPath.row] : cards[indexPath.row]
			
			//cell.summary.numberOfLines = 0
			cell.configureCell(with:card)
			
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	
	@objc func showSortActionSheet() {
		
		
		let alertController = UIAlertController(title: "Sorting ", message: nil, preferredStyle: .actionSheet)
		
		let AZAction = UIAlertAction(title: "A-Z", style: .default) { _ in
			
			self.cards.sort() {$0.name! < $1.name!}
			self.tableView.reloadData()
			
		}
		
		let ZAAction = UIAlertAction(title: "Z-A", style: .default) { _ in
			
			self.cards.sort(){$0.name! > $1.name!}
			self.tableView.reloadData()
			
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
			
		}
		
		// Add the actions.
		alertController.addAction(AZAction)
		alertController.addAction(ZAAction)
		alertController.addAction(cancelAction)
		
		
		// Configure the alert controller's popover presentation controller if it has one.
		if let popoverPresentationController = alertController.popoverPresentationController {
			// This method expects a valid cell to display from.
			//popoverPresentationController.canOverlapSourceViewRect = true
			popoverPresentationController.backgroundColor = UIColor.brown
			popoverPresentationController.sourceView = view
			popoverPresentationController.permittedArrowDirections = .up
		}
		
		present(alertController, animated: true, completion: nil)
		
		
	}

	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		
		//DELETE BUTTON
		let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
			// Delete the row from the data store
			if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
				let context = appDelegate.persistentContainer.viewContext
				let restaurantToDelete = self.fetchResultController.object(at: indexPath)
				context.delete(restaurantToDelete)
				
				if restaurantToDelete.frontimage != nil {
					FileManagerHelper.instance.deleteImageFromDisk(withName: restaurantToDelete.frontimage!)
				}
				
				if restaurantToDelete.backtimage != nil {
					FileManagerHelper.instance.deleteImageFromDisk(withName: restaurantToDelete.backtimage!)
				}
				
				
				appDelegate.saveContext()
			}
			
			// Call completion handler with true to indicate
			completionHandler(true)
		}
		
		//SHARE BUTTON
		let shareAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
			
			let defaultText = "Check this out :" + self.cards[indexPath.row].name!
			
			let activityController: UIActivityViewController
			
			if let cardImage = self.cards[indexPath.row].frontimage,
				let imageToShare = FileManagerHelper.instance.getImageFromDisk(withName: cardImage) {
				activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
			} else  {
				activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
			}
			
			if let popoverController = activityController.popoverPresentationController {
				if let cell = tableView.cellForRow(at: indexPath) {
					popoverController.sourceView = cell
					popoverController.sourceRect = cell.bounds
				}
			}
			
			self.present(activityController, animated: true, completion: nil)
			completionHandler(true)
		}
		
		//EDIT BUTTON
		let editAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
			
			
			if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
				let context = appDelegate.persistentContainer.viewContext
				let restaurant = self.fetchResultController.object(at: indexPath)
				
					self.performSegue(withIdentifier: "EditCard", sender: restaurant)
				
			}

			
			//if var card = self.cards[indexPath.row]  {
				//self.performSegue(withIdentifier: "EditCard", sender: self.cards[indexPath.row])
			//}
			
			
			// Call completion handler with true to indicate
			completionHandler(true)
		}

		
		
		// Customize the action buttons
		deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
		deleteAction.image = UIImage(named: "delete")
		shareAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
		shareAction.image = UIImage(named: "share")
		editAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
		editAction.image = UIImage(named: "edit")
		
		
		let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction,editAction])
		
		return swipeConfiguration
	}
	
	
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if searchController.isActive {
			return false
		} else {
			return true
		}
	}
	
	
	
	func filterContent(for searchText: String) {
		searchResults = cards.filter({ (card) -> Bool in
			if let name = card.name {
				let isMatch = name.localizedCaseInsensitiveContains(searchText)
				return isMatch
			} 
			
			return true
		})
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		if let searchText = searchController.searchBar.text {
			filterContent(for: searchText)
			tableView.reloadData()
		}
	}
	
	
	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DetailCardViewController"  {
			if let indexPath = tableView.indexPathForSelectedRow {
				let destinationController = segue.destination as! DetailCardViewController
				destinationController.card = (searchController.isActive) ? searchResults[indexPath.row] : cards[indexPath.row]
			}
		}
		if segue.identifier ==  "EditCard" {
			
			//print(tableView.indexPathForSelectedRow )
			
			if let destination = segue.destination as? NewCardViewController {
				if let editedCard = sender as? CardMO {
					destination.card = editedCard
				}
			}
		}
		
	}

	
	
	
	// MARK: - NSFetchedResultsControllerDelegate methods
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch type {
		case .insert:
			if let newIndexPath = newIndexPath {
				tableView.insertRows(at: [newIndexPath], with: .fade)
			}
		case .delete:
			if let indexPath = indexPath {
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
		case .update:
			if let indexPath = indexPath {
				tableView.reloadRows(at: [indexPath], with: .fade)
			}
		default:
			tableView.reloadData()
		}
		
		if let fetchedObjects = controller.fetchedObjects {
			cards = fetchedObjects as! [CardMO]
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func search(with searchString: String) {
		searchController.searchBar.text = searchString
		searchController.searchBar.becomeFirstResponder()
	}
	
	
}

extension CardsTableViewController:UITableViewDataSourcePrefetching {
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		
		//DispatchQueue.global(qos:DispatchQoS.QoSClass.default).async {
			
			//for i in indexPaths {
				
			//	let cachedImage = self.ch
				
			//}
			
		//}
		
	}
	
}



public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
}
