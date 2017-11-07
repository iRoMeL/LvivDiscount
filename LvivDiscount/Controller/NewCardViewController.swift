//
//  NewCardViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData

class NewCardViewController: UITableViewController,UIGestureRecognizerDelegate, WDImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var nameTextField: RoundedTextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var backImageView: UIImageView!
	
	fileprivate var imagePicker: WDImagePicker!
	fileprivate var imagePickerController: UIImagePickerController!
	
	fileprivate var choosingFront = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color
		
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapfrontImageView(sender:)))
		frontImageView.addGestureRecognizer(tapGesture)
		
		let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(self.tapbackImageView(sender:)))
		backImageView.addGestureRecognizer(tapGestureBack)
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	@objc func tapfrontImageView(sender: UITapGestureRecognizer) {
		choosingFront = true
		chooseImage()
	}
	
	@objc func tapbackImageView(sender: UITapGestureRecognizer) {
		choosingFront = false
		chooseImage()
	}
	
	
	
	
	func chooseImage() {
		
		
		let photoSourceRequestController = UIAlertController(title: "", message: NSLocalizedString("Choose your photo source", comment: "Choose your photo source"), preferredStyle: .actionSheet)
		
		let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { (action) in
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				self.imagePicker = WDImagePicker(sourceType: .camera)
				///self.imagePicker.cropSize = CGSize(width: 320, height: 200)
				self.imagePicker.delegate = self
				self.imagePicker.resizableCropArea = true
				self.present(self.imagePicker.imagePickerController, animated: true, completion: nil)
			}
		})
		
		let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: "Photo library"), style: .default, handler: { (action) in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				self.imagePicker = WDImagePicker(sourceType: .photoLibrary)
				//self.imagePicker.cropSize = CGSize(width: 320, height: 200)
				self.imagePicker.delegate = self
				self.imagePicker.resizableCropArea = true
				self.present(self.imagePicker.imagePickerController, animated: true, completion: nil)
			}
		})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
		}
		
		photoSourceRequestController.addAction(cameraAction)
		photoSourceRequestController.addAction(photoLibraryAction)
		photoSourceRequestController.addAction(cancelAction)
		
		present(photoSourceRequestController, animated: true, completion: nil)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		
		if nameTextField.text == "" ||  descriptionTextView.text == "" {
			
			let alertController = UIAlertController(title: NSLocalizedString("Oops", comment: "Oops"), message: NSLocalizedString("We can't proceed because one of the fields is blank. Please note that all fields are required.", comment: "Input error message"), preferredStyle: .alert)
			
			let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
			
			alertController.addAction(alertAction)
			present(alertController, animated: true, completion: nil)
			
			return
		}
		
		print("Name: \(nameTextField.text ?? "")")
		print("Description: \(descriptionTextView.text ?? "")")
		
		// Saving the card to database
		if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
			let newCard = CardMO(context: appDelegate.persistentContainer.viewContext)
			newCard.name = nameTextField.text
			newCard.summary = descriptionTextView.text
			
			if let cardImage = frontImageView.image {
				
				
				let frontImage = nameTextField.text! + "_front.jpeg"
				
				newCard.frontimage	= frontImage
				saveImageDocumentDirectory(image: cardImage, imageName: frontImage)
				
				
				print("Saving data to context ...")
				appDelegate.saveContext()
			}
			
			if let cardImage = backImageView.image {
				
				
				let backside = nameTextField.text! + "_back.jpeg"
				
				newCard.backtimage	= backside
				saveImageDocumentDirectory(image: cardImage, imageName: backside)
				
				
				print("Saving data to context ...")
				appDelegate.saveContext()
			}
		}
		
		dismiss(animated: true, completion: nil)
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			
			
		}
	}
	
	func saveImageDocumentDirectory(image : UIImage, imageName: String){
		let fileManager = FileManager.default
		let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
		//let image = UIImage(named: imageName)
		print(paths)
		let imageData = UIImageJPEGRepresentation(image, 0.5)
		fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			if choosingFront {
				frontImageView.image = selectedImage
				frontImageView.contentMode = .scaleAspectFill
				frontImageView.clipsToBounds = true
				
			} else {
				backImageView.image = selectedImage
				backImageView.contentMode = .scaleAspectFill
				backImageView.clipsToBounds = true
				
			}
		}
		
		
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
		if choosingFront {
			
			self.frontImageView.image = pickedImage
		}else{
			self.backImageView.image = pickedImage
		}
		self.hideImagePicker()
	}
	
	func hideImagePicker() {
		
		self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
		
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	
}
