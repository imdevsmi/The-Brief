//
//  configureImage .swift
//  News
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = nil, targetSize: CGSize? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            
            return
        }
        
        self.kf.setImage(with: url,placeholder: placeholder, options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .transition(.fade(0.1)),
                .memoryCacheExpiration(.seconds(300)),
                .backgroundDecode])
    }
}
