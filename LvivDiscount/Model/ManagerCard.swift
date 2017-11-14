//
//  ManagerCard.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 10.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ManagerCard {
	
	private let context 	= (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	public func addNew(name: String, summary: String, barcode: String, frontImage: UIImage?, backImage: UIImage?, barcodeImage: UIImage?, tag:Int ) {
		
		let newCard		= CardMO(context: context)
		let uuid    	= UUID().uuidString
		
		
		newCard.name = name
		newCard.summary = summary
		newCard.barcode = barcode
		newCard.tag = Int64(tag)
		newCard.uid = uuid
		
		if let frontImg = frontImage {
			let frontSide = uuid + "_front.jpeg"
			newCard.frontimage	= frontSide
			FileManagerHelper.instance.saveImageToDisk(image: frontImg, withName: frontSide)
		}
		
		if let backImg = backImage {
			let backside = uuid + "_back.jpeg"
			newCard.backtimage	= backside
			FileManagerHelper.instance.saveImageToDisk(image: backImg, withName: backside)
		}
		
		
		if let barcodeImg = barcodeImage {
			let barcodeSide = uuid + "_barcode.jpeg"
			newCard.barcodeimage	= barcodeSide
			FileManagerHelper.instance.saveImageToDisk(image: barcodeImg, withName: barcodeSide)
		}
		
		
		saveContext()
		
	}
	
	
	
	public func edit(card: CardMO, name: String, summary: String, barcode: String, frontImage: UIImage?, backImage: UIImage?, barcodeImage: UIImage?, tag:Int) {
		
		card.name 		= name
		card.summary 	= summary
		card.barcode 	= barcode
		card.tag 		= Int64(tag)
		let  uuid 		= card.uid!
		
		if let frontImg = frontImage {
			let frontSide = uuid + "_front.jpeg"
			card.frontimage	= frontSide
			FileManagerHelper.instance.saveImageToDisk(image: frontImg, withName: frontSide)
		}
		
		if let backImg = backImage {
			let backside = uuid + "_back.jpeg"
			card.backtimage	= backside
			FileManagerHelper.instance.saveImageToDisk(image: backImg, withName: backside)
		}
		
		
		if let barcodeImg = barcodeImage {
			let barcodeSide = uuid + "_barcode.jpeg"
			card.barcodeimage	= barcodeSide
			FileManagerHelper.instance.saveImageToDisk(image: barcodeImg, withName: barcodeSide)
		}
		
		
		
		saveContext()
	}
	
	
	public func getCards(withtag tag : Int? = nil, completion: @escaping ((_ cards: [CardMO]) -> Void)) {
		
		var arrayCards: [CardMO] = []
		
		let fetchRequest: NSFetchRequest<CardMO> = CardMO.fetchRequest()
		
		if tag != nil {
			fetchRequest.predicate = NSPredicate(format: "tag == %d", tag!)
		}
		
//		if let fetchedResults = try! context.fetch(fetchRequest). {
//			for item in fetchedResults {
//				arrayCards.append(item)
//			}
//		}
		
		arrayCards = try! context.fetch(fetchRequest)
		
		completion(arrayCards)
		
	}
	
	
	public func delete(card: CardMO){
		
		if card.frontimage != nil {
			FileManagerHelper.instance.deleteImageFromDisk(withName: card.frontimage!)
		}
		
		if card.backtimage != nil {
			FileManagerHelper.instance.deleteImageFromDisk(withName: card.backtimage!)
		}
		
		if card.barcodeimage != nil {
			FileManagerHelper.instance.deleteImageFromDisk(withName: card.barcodeimage!)
		}

		
		context.delete(card)

		saveContext()
		
	}
	
	private func saveContext () {
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	
	
}
