//
//  CardsTableViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData

class CardsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
	
	

	var cards:[CardMO] = []
	var searchResults: [CardMO] = []
	
	var fetchResultController: NSFetchedResultsController<CardMO>!
	var searchController: UISearchController!
	
	@IBAction func unwindToHome(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.cellLayoutMarginsFollowReadableWidth = true
		navigationController?.navigationBar.prefersLargeTitles = true
		
		//tableView.tableFooterView = UIView()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		
		
		// Adding a search bar
		searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = NSLocalizedString("Search cards...", comment: "Search cards...")
		searchController.searchBar.barTintColor = .white
		searchController.searchBar.backgroundImage = UIImage()
		//searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
		        self.navigationItem.searchController = searchController
		//tableView.tableHeaderView = searchController.searchBar

		
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
			
			cell.configureCell(withcard:card)
			
			return cell
		}
		
		return UITableViewCell()
    }
	

	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
			// Delete the row from the data store
			if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
				let context = appDelegate.persistentContainer.viewContext
				let restaurantToDelete = self.fetchResultController.object(at: indexPath)
				context.delete(restaurantToDelete)
				
				appDelegate.saveContext()
			}
			
			// Call completion handler with true to indicate
			completionHandler(true)
		}
		
		let shareAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
			
			let defaultText = "Check this out " + self.cards[indexPath.row].name!
			
			let activityController: UIActivityViewController
			
			//if let cardImage = self.cards[indexPath.row].image,
			//	let imageToShare = UIImage(data: cardImage as Data) {
			//	activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
			//} else  {
				activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
			//}
			
			if let popoverController = activityController.popoverPresentationController {
				if let cell = tableView.cellForRow(at: indexPath) {
					popoverController.sourceView = cell
					popoverController.sourceRect = cell.bounds
				}
			}
			
			self.present(activityController, animated: true, completion: nil)
			completionHandler(true)
		}
		
		// Customize the action buttons
		deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
		deleteAction.image = UIImage(named: "delete")
		shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
		shareAction.image = UIImage(named: "share")
		
		let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
		
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
			
			return false
		})
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		if let searchText = searchController.searchBar.text {
			filterContent(for: searchText)
			tableView.reloadData()
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	
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

}
