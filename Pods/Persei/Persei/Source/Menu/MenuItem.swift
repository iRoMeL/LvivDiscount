// For License please refer to LICENSE file in the root of Persei project

import UIKit

public struct MenuItem {
    
    public var image: UIImage
    public var highlightedImage: UIImage?
    
    public var backgroundColor = UIColor(red:0.26, green:0.25, blue:0.37, alpha:1)//UIColor(red: 50.0 / 255.0, green: 49.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    public var highlightedBackgroundColor = UIColor(red:130/255.0, green:169/255.0, blue:243/255.0, alpha:1)//UIColor(red: 1.0, green: 61.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    
    public var shadowColor = UIColor(white: 0.1, alpha: 0.3)
    
    // MARK: - Init
    public init(image: UIImage, highlightedImage: UIImage? = nil) {
        self.image = image
        self.highlightedImage = highlightedImage
    }    
}
