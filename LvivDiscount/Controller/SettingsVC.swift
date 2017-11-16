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

	
	@IBOutlet weak var showSettings: UILabel!
	


	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0{
			if indexPath.row == 0  {
				
				
				if showDetailView  {
					showSettings.text = "Edit View"
					showDetailView = false
				} else {
					showSettings.text = "Detail View"
					showDetailView = true
					
				}
				
				
			}
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if showDetailView  {
			showSettings.text = "Detail View"
		} else {
			showSettings.text = "Edit View"
		}
		
		tableView.backgroundColor = Theme.Colors.BackgroundColor.color
		tableView.tableFooterView = UIView()

		
    }
	
}
