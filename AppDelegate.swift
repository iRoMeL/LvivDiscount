//
//  AppDelegate.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 30.10.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	enum QuickAction: String {
		case OpenCards = "OpenCards"
		case OpenSettings = "OpenSettings"
		case NewCard = "NewCard"
		
		init?(fullIdentifier: String) {
			
			guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last else {
				return nil
			}
			
			self.init(rawValue: shortcutIdentifier)
		}
	}



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		
		// Style the app
		applyAppAppearance()
		window?.tintColor		= Theme.Colors.TintColor.color
		window?.backgroundColor = Theme.Colors.BackgroundColor.color
		
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

		
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

		guard let tabBarController = window?.rootViewController as? UITabBarController else {
			return false
		}
		
		if let navController = tabBarController.viewControllers?[0] {
			let cardsTableViewController = navController.childViewControllers[0]
			cardsTableViewController.restoreUserActivityState(userActivity)
		} else {
			return false
		}
		
		return true
		
	}
	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "Card")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
	
	
	// MARK: - 3D Touch
	
	
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		
		completionHandler(handleQuickAction(shortcutItem: shortcutItem))
	}
	
	private func handleQuickAction(shortcutItem: UIApplicationShortcutItem) -> Bool {
		
		let shortcutType = shortcutItem.type
		guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) else {
			return false
		}
		
		guard let tabBarController = window?.rootViewController as? UITabBarController else {
			return false
		}
		
		switch shortcutIdentifier {
		case .OpenCards:
			tabBarController.selectedIndex = 0
		case .OpenSettings:
			tabBarController.selectedIndex = 1
		case .NewCard:
			if let navController = tabBarController.viewControllers?[0] {
				let cardsTableViewController = navController.childViewControllers[0]
				cardsTableViewController.performSegue(withIdentifier: "NewCardSpotlight", sender: nil)
			} else {
				return false
			}
		}
		
		return true
	}
	
	//MARK:- CUSTOM URL
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		
//		print("url \(url)")
//		print("url host :\(url.host!)")
//		print("url path :\(url.path)")
		
		let cardName : String? = url.host
		
		guard let tabBarController = window?.rootViewController as? UITabBarController else {
			return false
		}
		
		if let navController = tabBarController.viewControllers?[0] {
			let cardsTableViewController = navController.childViewControllers[0]
			cardsTableViewController.performSegue(withIdentifier: "NewCardSpotlight", sender: cardName)
		} else {
			return false
		}

		return true
	
	}
	

}

