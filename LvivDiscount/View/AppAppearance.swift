//
//  AppAppearance.swift
//  RoMeL
//
//  Created by Roman Melnychok on 13.11.17
//  Copyright © 2016 RoMeL. All rights reserved.
//

import UIKit

struct Theme {
	
	enum Colors {
		case TintColor
		case BackgroundColor
		case DarkBackgroundColor
		case SectionHeader
		case Foreground
		case LightTextColor
		
		var color: UIColor {
			switch self {
			case .TintColor: return UIColor(red:130/255.0, green:169/255.0, blue:243/255.0, alpha:1)
			case .BackgroundColor: return UIColor(red:44/255.0, green:50/255.0, blue:63/255.0, alpha:1)
			case .DarkBackgroundColor: return UIColor(red:0.11, green:0.1, blue:0.22, alpha:1)
			case .SectionHeader: return UIColor(hue:0.67, saturation:0.4, brightness:0.25, alpha:1)
			case .Foreground: return UIColor(red:0.26, green:0.25, blue:0.37, alpha:1)
			case .LightTextColor: return UIColor(red:0.64, green:0.65, blue:0.8, alpha:1)
			}
		}
	}
	
	enum Fonts {
		case TitleFont
		case BoldTitleFont
		
		var font: UIFont {
			switch self {
			case .BoldTitleFont: return UIFont(name: "Copperplate-Bold", size: 17)!
			case .TitleFont: return UIFont(name: "Copperplate", size: 16)!
			}
		}
	}
}

extension UIColor {
  static var ggGreen : UIColor {
    //return UIColor(red: 127/255.0, green: 148/255.0, blue: 49/255.0, alpha: 1.0)
	return UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
	}
  
  static var ggDarkGreen : UIColor {
    //return UIColor(red: 48/255.0, green: 56/255.0, blue: 19/255.0, alpha: 1.0)
	return UIColor(red: 88/255.0, green: 86/255.0, blue: 214/255.0, alpha: 1.0)  }
}

func applyAppAppearance() {
  styleNavBar()
  styleTabBar()
  styleTableView()
	
}


private func styleTableView() {
	
	let appearanceProxy = UITableViewCell.appearance()
	appearanceProxy.backgroundColor					= Theme.Colors.BackgroundColor.color
	appearanceProxy.backgroundView?.backgroundColor = Theme.Colors.BackgroundColor.color

	
}




private func styleNavBar() {
	
	//test
	let navBarAppearance = UINavigationBar.appearance()
	//navBarAppearance.titleTextAttributes = [
		//NSAttributedStringKey.font: Theme.Fonts.BoldTitleFont.font,
	//	NSAttributedStringKey.foregroundColor: Theme.Colors.TintColor.color
	//]
	
	
	navBarAppearance.barStyle = .black
	
	navBarAppearance.tintColor = Theme.Colors.TintColor.color
	navBarAppearance.backgroundColor = Theme.Colors.BackgroundColor.color
}

private func styleTabBar() {
  let appearanceProxy = UITabBar.appearance()
	appearanceProxy.barStyle = UIBarStyle.black
}

private func styleTintColor() {
  let appearanceProxy = UIView.appearance()
  appearanceProxy.tintColor = UIColor.ggGreen
}

