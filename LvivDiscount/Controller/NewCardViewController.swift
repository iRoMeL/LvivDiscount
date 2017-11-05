//
//  NewCardViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData

class NewCardViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var nameTextField: RoundedTextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	
	@IBOutlet weak var frontImageView: UIImageView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
				
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
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
			//	newCard = UIImagePNGRepresentation(cardImage)
			
			let frontImage = nameTextField.text! + ".jpeg"
			
			newCard.frontimage	= frontImage
			saveImageDocumentDirectory(image: cardImage, imageName: frontImage)
			
			
			print("Saving data to context ...")
			appDelegate.saveContext()
			}
		}
		
		dismiss(animated: true, completion: nil)
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			
			let photoSourceRequestController = UIAlertController(title: "", message: NSLocalizedString("Choose your photo source", comment: "Choose your photo source"), preferredStyle: .actionSheet)
			
			let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default, handler: { (action) in
				if UIImagePickerController.isSourceTypeAvailable(.camera) {
					let imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.allowsEditing = false
					imagePicker.sourceType = .camera
					
					let mainView = UIView.init(frame: CGRect.init(x: 150, y: 150, width: self.view.frame.size.width - 150, height: self.view.frame.size.height-150))
					
					
					
					imagePicker.cameraOverlayView = mainView

					
					self.present(imagePicker, animated: true, completion: nil)
				}
			})
			
			let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: "Photo library"), style: .default, handler: { (action) in
				if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
					let imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.allowsEditing = false
					imagePicker.sourceType = .photoLibrary
					
					
					//imagePicker.cameraOverlayView =
					
					self.present(imagePicker, animated: true, completion: nil)
				}
			})
			
			photoSourceRequestController.addAction(cameraAction)
			photoSourceRequestController.addAction(photoLibraryAction)
			
			present(photoSourceRequestController, animated: true, completion: nil)
			
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
			frontImageView.image = selectedImage
			frontImageView.contentMode = .scaleAspectFill
			frontImageView.clipsToBounds = true			
		}
		
		let leadingConstraint = NSLayoutConstraint(item: frontImageView, attribute: .leading, relatedBy: .equal, toItem: frontImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
		leadingConstraint.isActive = true
		
		let trailingConstraint = NSLayoutConstraint(item: frontImageView, attribute: .trailing, relatedBy: .equal, toItem: frontImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
		trailingConstraint.isActive = true
		
		let topConstraint = NSLayoutConstraint(item: frontImageView, attribute: .top, relatedBy: .equal, toItem: frontImageView.superview, attribute: .top, multiplier: 1, constant: 0)
		topConstraint.isActive = true
		
		let bottomConstraint = NSLayoutConstraint(item: frontImageView, attribute: .bottom, relatedBy: .equal, toItem: frontImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
		bottomConstraint.isActive = true
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	
	

	
}
