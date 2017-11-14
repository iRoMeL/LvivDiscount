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
import CoreSpotlight
import MobileCoreServices


class CardsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
	
	fileprivate var menu: MenuView!
	private var cards:[CardMO] = []
	private var searchResults: [CardMO] = []
	private let manager = ManagerCard()
	private var fetchResultController: NSFetchedResultsController<CardMO>!
	private var searchController: UISearchController!
	
	@IBAction func unwindToHome(segue: UIStoryboardSegue) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Menu
	
	fileprivate func loadMenu() {
		menu = {
			let menu = MenuView()
			menu.delegate = self
			
			menu.items = items
			return menu
		}()
		
		tableView.addSubview(menu)
	}
	
	fileprivate let items = (0..<7).map {
		MenuItem(image: UIImage(named: "menu_icon_\($0)")!)
	}
	
	fileprivate var model:String = "" {
		didSet {
			
		}
	}
	
	// MARK: - VIEW
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadMenu()
		
		//3D-TOUCH
		if (traitCollection.forceTouchCapability == .available) {
			registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
		}
		
		createQuickActions()
		
		
		tableView.cellLayoutMarginsFollowReadableWidth = true
		//navigationController?.navigationBar.prefersLargeTitles = true
		
		//Theme
		tableView.separatorColor = Theme.Colors.LightTextColor.color
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color
		
		tableView.estimatedRowHeight = 120
		tableView.rowHeight = UITableViewAutomaticDimension
		
		
		//кнопка  Sort
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sorting"), style: .plain, target: self, action: #selector(showSortActionSheet))
		
		
		//при початковому завантажені приховуємо пошук
		//let offset = CGPoint(x: 0, y: 44)
		//tableView.setContentOffset(offset, animated: true)
		
		// Adding a search bar
		searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = NSLocalizedString("Search cards...", comment: "Search cards...")
		searchController.searchBar.barTintColor				= Theme.Colors.BackgroundColor.color
		searchController.searchBar.tintColor				= Theme.Colors.TintColor.color
		searchController.searchBar.enablesReturnKeyAutomatically = true
		searchController.searchBar.keyboardAppearance		= .dark
		searchController.searchBar.sizeToFit()
		//searchController.searchBar.setTextColor(color: .brown)

		
		//		if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
		//			textFieldInsideSearchBar.textColor = Theme.Colors.TintColor.color
		//			textFieldInsideSearchBar.borderStyle = .roundedRect
		//			textFieldInsideSearchBar.backgroundColor = Theme.Colors.BackgroundColor.color
		//		}
		
		
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
		
		setupSearchableContent()
	}
	
	//MARK:- SPOTLIGHT
	func setupSearchableContent() {
		var searchableItems:Array<CSSearchableItem> = []
		
		for item in cards {
			
			//let imagePathParts                              = movie.image.componentsSeparatedByString(".")
			
			let searchableItemAttributeSet                  = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
			
			searchableItemAttributeSet.title                = item.name
			
			//searchableItemAttributeSet.thumbnailURL         =  NSBundle.mainBundle().URLForResource(imagePathParts.first, withExtension: imagePathParts.last)
			searchableItemAttributeSet.thumbnailURL 		= URL(fileURLWithPath: item.frontimage!)//) (item.frontimage)// ?? item.backtimage
			searchableItemAttributeSet.contentDescription   = item.summary ?? ""
			searchableItemAttributeSet.keywords             = [item.name ?? ""] //+ (item.summary ?? "")
			
			//
			let searchableItem = CSSearchableItem(uniqueIdentifier: "com.Spotlight.\(item.uid ?? "0")", domainIdentifier: "cards", attributeSet: searchableItemAttributeSet)
			searchableItems.append(searchableItem)
		}
		
		//
		CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: ["cards"]) { (error) -> Void in
			if error != nil {
				print(error!.localizedDescription)
			} else {
				CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
					if error != nil {
						print(error!.localizedDescription)
					}
				}
			}
		}
	}
	
	override func restoreUserActivityState(_ activity: NSUserActivity) {
		if activity.activityType == CSSearchableItemActionType {
			if let userInfo = activity.userInfo {
				let selectedCard   = userInfo[CSSearchableItemActivityIdentifier] as! String
				let idselectedCard  = selectedCard.components(separatedBy: ".").last!
				let scards = cards.filter({ (card) -> Bool in
					return card.uid == idselectedCard
				})
				
				if let findedcards = scards.first {
					performSegue(withIdentifier: "EditCard", sender: findedcards)
				}
			}
		}
	}
	
	// MARK: - Table view data source/delegate
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFilterActive{
			return searchResults.count
		} else {
			return cards.count
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardCell {
			
			let card = (isFilterActive) ? searchResults[indexPath.row] : cards[indexPath.row]
			
			
			cell.configureCell(with:card)
			
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if isFilterActive {
			return false
		} else {
			return true
		}
	}
	
	
	//	MARK: - Sorting
	
	@objc func showSortActionSheet() {
		
		let alertController = UIAlertController(title: "Sorting ", message: nil, preferredStyle: .actionSheet)
		
		let AZAction = UIAlertAction(title: "TITLE: A-Z", style: .default) { _ in
			
			self.cards.sort() {$0.name! < $1.name!}
			self.tableView.reloadData()
			
		}
		
		let ZAAction = UIAlertAction(title: "TITLE: Z-A", style: .default) { _ in
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
	
	//MARK: - SWIPE
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		
		//DELETE BUTTON
		let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
			// Delete the row from the data store
			
			let cardToDelete = self.fetchResultController.object(at: indexPath)
			
			self.manager.delete(card: cardToDelete)
			
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
			
			let editCard = self.fetchResultController.object(at: indexPath)
			self.performSegue(withIdentifier: "EditCard", sender: editCard)
			
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
	
	//MARK: - SEARCH
	var isFilterActive: Bool {
		return (searchController.isActive && searchController.searchBar.text != "")
	}
	
	func search(with searchString: String) {
		searchController.searchBar.text = searchString
		searchController.searchBar.becomeFirstResponder()
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
				destinationController.card = (isFilterActive) ? searchResults[indexPath.row] : cards[indexPath.row]
			}
		}
		if segue.identifier ==  "EditCard" {
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
			setupSearchableContent()
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	
	
}


extension CardsTableViewController: MenuViewDelegate {
	
	func menu(_ menu: MenuView, didSelectItemAt index: Int) {
		
		if index==0 {
			manager.getCards() { (arrayOfCards) in
				self.cards = arrayOfCards
			}
		} else{
			manager.getCards(withtag: index){ (arrayOfCards) in
				self.cards = arrayOfCards
			}
		}
		
		
		
		tableView.reloadData()
		
	}
}

//MARK: - 3D-TOUCH
extension CardsTableViewController : UIViewControllerPreviewingDelegate{
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		
		guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
		
		guard let cell = tableView.cellForRow(at: indexPath) else {
			return nil
		}
		
		guard let detailCardViewControler = storyboard?.instantiateViewController(withIdentifier: "DetailCardViewController")as? DetailCardViewController else {
			return nil
		}
		
		let selectedCard = cards[indexPath.row]
		detailCardViewControler.card = selectedCard
		//detailCardViewControler.preferredContentSize = CGSize(width: 0.0, height: 460)
		
		
		previewingContext.sourceRect = cell.frame
		
		return detailCardViewControler
	}
	
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		show(viewControllerToCommit, sender: self)
	}
	
	func createQuickActions() {
		// Add Quick Actions
		if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
			if let bundleIdentifier = Bundle.main.bundleIdentifier {
				let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenCards", localizedTitle: "Cards", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "loyalty-card"), userInfo: nil)
				let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenSettings", localizedTitle: "Settings", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "tab_settings"), userInfo: nil)
				let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewCard", localizedTitle: "New Card", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
				UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
			}
		}
	}
	
}

public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
}


