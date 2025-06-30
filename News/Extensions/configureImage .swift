//
//  configureImage .swift
//  News
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = nil, targetSize: CGSize? = nil,completion: (() -> Void)? = nil) {
        guard let urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            completion?()
            return
        }
        
        var options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .transition(.fade(0.3)),
            .memoryCacheExpiration(.seconds(300)),
            .backgroundDecode
        ]
        
        if let targetSize {
            let processor = ResizingImageProcessor(referenceSize: targetSize, mode: .aspectFill)
            options.append(.processor(processor))
        }
        
        kf.setImage(with: url, placeholder: placeholder, options: options) { result in
            switch result {
            case .success(let value):
                if value.cacheType == .none {
                    self.alpha = 0
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    UIView.animate(withDuration: 0.4,
                                   delay: 0,
                                   usingSpringWithDamping: 0.75,
                                   initialSpringVelocity: 0.8,
                                   options: [.curveEaseOut],
                                   animations: {
                        self.alpha = 1
                        self.transform = .identity
                    })
                }
            case .failure:
                break
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
