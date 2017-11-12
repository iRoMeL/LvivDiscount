//
//  SettingsVC.swift
//  RoMeL
//
//  Created by Roman Melnychok on 30.10.16.
//  Copyright © 2016 RoMeL. All rights reserved.
//

import UIKit
import Foundation

class SettingsVC: UITableViewController {

    @IBOutlet weak var NaturalLanguageSupportSwitch: UISwitch!
    
    @IBAction func ChangeNLS(_ sender: UISwitch) {}
	
	@IBOutlet weak var episodeLanguage: UILabel!
	
	@IBOutlet weak var showLanguage: UILabel!
	
	@IBOutlet weak var loginBtn: UILabel!
	
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0{
			if indexPath.row == 0  {
				
				
//				if episodeLanguageUkrainian  {
//					episodeLanguage.text = "англійською"
//					episodeLanguageUkrainian = false
//				} else {
//					episodeLanguage.text = "українською"
//					episodeLanguageUkrainian = true
//					
//				}
				
				
			} else if indexPath.row == 1  {
				
//				if showLanguageUkrainian  {
//					showLanguage.text = "англійською"
//					showLanguageUkrainian = false
//				} else {
//					showLanguage.text = "українською"
//					showLanguageUkrainian = true
//				}
				
				
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//if episodeLanguageUkrainian  {
			episodeLanguage.text = "A-Z"
		//} else {
		//	episodeLanguage.text = "англійською"
		//}
		
//		if showLanguageUkrainian  {
//			showLanguage.text = "українською"
//		} else {
//			showLanguage.text = "англійською"
//		}
		
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color
		tableView.tableFooterView = UIView()

		
    }
	
}
