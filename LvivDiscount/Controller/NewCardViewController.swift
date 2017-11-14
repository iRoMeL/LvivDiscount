//
//  NewCardViewController.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 01.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit
import CoreData
import RSBarcodes_Swift
import AVFoundation

class NewCardViewController: UITableViewController,UIGestureRecognizerDelegate, WDImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,SetBarcodeDelegate{
	
	// MARK : IBOutlet
	
	@IBOutlet weak var nameTextField: RoundedTextField!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var barcodeImageView: UIImageView!
	@IBOutlet weak var barcodeTextField: RoundedTextField!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	// MARK : IBAction
	@IBAction func barcodeEntered(_ sender: RoundedTextField) {
		
		generateBarcodeImage()
	
	}
	
	// MARK : VARS
	private let manager = ManagerCard()
	private let gen = RSUnifiedCodeGenerator.shared
	private let limitLength = 13
	private let limitSummaryLength = 100
	private var barcodeType = AVMetadataObject.ObjectType.ean13.rawValue
	public  var card: CardMO?
	fileprivate var imagePicker: WDImagePicker!
	fileprivate var imagePickerController: UIImagePickerController!
	fileprivate var choosingFront = true
	
	//MARK: - BARCODE
	
	func getBarcodeType(nubmer : Int ) -> String {
		switch nubmer {
		case 8: return AVMetadataObject.ObjectType.ean8.rawValue
		case 13: return AVMetadataObject.ObjectType.ean13.rawValue
		default: return AVMetadataObject.ObjectType.code39.rawValue
		}
		
	}
	
	func setBarcode(withNumber number: String, andType type: String) {
	
		barcodeTextField.text = number
		barcodeType 		  = type
		barcodeImageView.subviews.forEach{ $0.removeFromSuperview()}
		
		if let barcodegen  = self.gen.generateCode(number, machineReadableCodeObjectType: type) {
			//print(self.barcodeType)
			
			barcodeImageView.layer.borderWidth = 1
			barcodeImageView.image = RSAbstractCodeGenerator.resizeImage(barcodegen, targetSize: barcodeImageView.bounds.size, contentMode: UIViewContentMode.center)
		}
		
	}
	
	func generateBarcodeImage()  {
		
		barcodeImageView.subviews.forEach{ $0.removeFromSuperview() }
		
		if let barcobeNumber = barcodeTextField.text {
			
		let barcodetype = getBarcodeType(nubmer: barcobeNumber.characters.count)
			
			if let barcodegen  = gen.generateCode(barcobeNumber, machineReadableCodeObjectType: barcodetype) {
				print(barcodetype)
				
				barcodeImageView.layer.borderWidth = 1
				barcodeImageView.image = RSAbstractCodeGenerator.resizeImage(barcodegen, targetSize: barcodeImageView.bounds.size, contentMode: UIViewContentMode.center)
				
				//barcodeImageView.image = RSAbstractCodeGenerator.resizeImage(barcodegen, targetSize: CGSize(width: 320, height: 200), contentMode: UIViewContentMode.center)
				
				
				
			} else {
				barcodeImageView.image = UIImage()
				addLabel(onImageView: barcodeImageView, withText: "WRONG BARCODE NUMBER")
			}
			
		} else {
			addLabel(onImageView: barcodeImageView, withText: "SCAN BARCODE")
		}
		
	}
	
	
	// MARK:- NAVIGATION
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier ==  "Scan" {
			
			//print(tableView.indexPathForSelectedRow )
			
			if let destination = segue.destination as? BarcodeReaderViewController {
				if let obj = sender as? NewCardViewController {
					destination.delegate = obj
				}
			}
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
	}
	
	//	MARK: - VIEW
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color
		tableView.estimatedRowHeight = 150
		tableView.rowHeight = UITableViewAutomaticDimension

		updateFields()
		
		barcodeTextField.delegate = self
		descriptionTextView.delegate = self
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapfrontImageView(sender:)))
		frontImageView.addGestureRecognizer(tapGesture)
		
		let tapGestureBack = UITapGestureRecognizer(target: self, action: #selector(self.tapbackImageView(sender:)))
		backImageView.addGestureRecognizer(tapGestureBack)
		
		let tapGestureBarcode = UITapGestureRecognizer(target: self, action: #selector(self.tapbarcodeImageView(sender:)))
		barcodeImageView.addGestureRecognizer(tapGestureBarcode)
		
	}
	
	func updateFields() {
		
		if let editedCard  = card {
			// edit mode
			
			nameTextField.text = editedCard.name ?? ""
			descriptionTextView.text = editedCard.summary ?? ""
			barcodeTextField.text = editedCard.barcode ?? ""
			segmentedControl.selectedSegmentIndex = Int(editedCard.tag)
			
			
			if let imageFile = editedCard.frontimage {
				
				if let imageToRotate = FileManagerHelper.instance.getImageFromDisk(withName: imageFile) {
					frontImageView.image = imageToRotate
				}
				
			} else {
				addLabel(onImageView: frontImageView, withText: "ADD FRONTSIDE")
			}
			
			if let imageFile = editedCard.backtimage {
				
				if let imageToRotate = FileManagerHelper.instance.getImageFromDisk(withName: imageFile) {
					backImageView.image = imageToRotate
				}
				
			} else{
				addLabel(onImageView: backImageView, withText: "ADD BACKSIDE")
			}
			
			if let imageFile = editedCard.barcodeimage {
				
				if let imageToRotate = FileManagerHelper.instance.getImageFromDisk(withName: imageFile) {
					barcodeImageView.image = imageToRotate
				}
				
			} else {
				generateBarcodeImage()
			}
			
			
			
		} else {
			//new card
			
			addLabel(onImageView: frontImageView, withText: "ADD FRONTSIDE")
			addLabel(onImageView: backImageView, withText: "ADD BACKSIDE")
			addLabel(onImageView: barcodeImageView, withText: "SCAN BARCODE")
			
		}
		
		
		
	}
	
	private func addLabel(onImageView imageView:UIImageView, withText text:String) {
		
		let label =  UILabel()
		label.frame 			= imageView.bounds
		label.backgroundColor 	= UIColor.clear
		label.textColor 		= Theme.Colors.TintColor.color
		label.textAlignment 	= .center
		label.text 				= text
		imageView.addSubview(label)
		
	}
	
	//	MARK: - Tap Actions
	
	@objc func tapfrontImageView(sender: UITapGestureRecognizer) {
		choosingFront = true
		chooseImage()
	}
	
	@objc func tapbackImageView(sender: UITapGestureRecognizer) {
		choosingFront = false
		chooseImage()
	}
	
	@objc func tapbarcodeImageView(sender: UITapGestureRecognizer) {
		
		performSegue(withIdentifier: "Scan", sender: self)
		
	}
	

	
	//	MARK: - TEXT Limit
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text else { return true }
		let newLength = text.characters.count + string.characters.count - range.length
		return newLength <= limitLength
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard let textsummary = textView.text else { return true }
		let newLength = textsummary.characters.count + text.characters.count - range.length
		return newLength <= limitSummaryLength
	}
	
	//MARK: - SAVE
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		
		if nameTextField.text == "" ||  descriptionTextView.text == "" || barcodeTextField.text == "" || (frontImageView.image == nil && backImageView.image == nil)  || barcodeImageView.image == nil  {
			
			let alertController = UIAlertController(title: NSLocalizedString("Oops", comment: "Oops"), message: NSLocalizedString("We can't proceed because all least one of the required field is blank", comment: "Input error message"), preferredStyle: .alert)
			
			let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
			
			alertController.addAction(alertAction)
			present(alertController, animated: true, completion: nil)
			
			return
		}
		
		print("Name: \(nameTextField.text ?? "")")
		print("Description: \(descriptionTextView.text ?? "")")

		
		if let editedCard = card {
			//edit
			manager.edit(card: editedCard, name: nameTextField.text!, summary: descriptionTextView.text!, barcode: barcodeTextField.text!, frontImage: frontImageView.image, backImage: backImageView.image, barcodeImage: barcodeImageView.image, tag: segmentedControl.selectedSegmentIndex)
			
		} else {
			//creat new card
			manager.addNew(name: nameTextField.text!, summary: descriptionTextView.text!, barcode: barcodeTextField.text!, frontImage: frontImageView.image, backImage: backImageView.image, barcodeImage: barcodeImageView.image, tag: segmentedControl.selectedSegmentIndex)
			
		}
		
		self.navigationController?.popToRootViewController(animated: true)
		
	}
	
	//	MARK: - IMAGE:CHOOSE
	
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

		
	//MARK: - IMAGE_PICKER
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			if choosingFront {
				frontImageView.image = selectedImage
				frontImageView.contentMode = .scaleAspectFill
				frontImageView.clipsToBounds = true
				frontImageView.subviews.forEach{ $0.removeFromSuperview() }
				
			} else {
				backImageView.image = selectedImage
				backImageView.contentMode = .scaleAspectFill
				backImageView.clipsToBounds = true
				backImageView.subviews.forEach{ $0.removeFromSuperview() }
			}
		}
		
		
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func imagePicker(_ imagePicker: WDImagePicker, pickedImage: UIImage) {
		if choosingFront {
			
			self.frontImageView.image = pickedImage
			self.frontImageView.subviews.forEach{ $0.removeFromSuperview() }
		}else{
			self.backImageView.image = pickedImage
			self.backImageView.subviews.forEach{ $0.removeFromSuperview() }
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
