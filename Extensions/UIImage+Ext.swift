//
//  UIImage+Ext.swift
//  LvivDiscount
//
//  Created by Roman Melnychok on 07.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func rotate(degrees: CGFloat) -> UIImage? {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * .pi
        }

        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
        let transformation = CGAffineTransform(rotationAngle: degreesToRadians(degrees))

        rotatedViewBox.transform = transformation
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)
        guard let temporaryBitmap = UIGraphicsGetCurrentContext(), let transformingImage = cgImage else {
            return nil
        }

        temporaryBitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        temporaryBitmap.rotate(by: degreesToRadians(degrees))
        temporaryBitmap.scaleBy(x: 1.0, y: -1.0)

        let temporaryRect = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)

        temporaryBitmap.draw(transformingImage, in: temporaryRect)

        guard let rotatedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        UIGraphicsEndImageContext()

        return rotatedImage
    }
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
	
	let scale = newWidth / image.size.width
	let newHeight = image.size.height * scale
	UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
	image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	
	return newImage!
}
