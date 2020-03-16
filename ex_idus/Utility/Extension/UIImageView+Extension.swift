//
//  UIImageView+Method.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/09.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher



extension UIImageView {
    
    func load(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString, options: nil) { (image, _) in
            if let image = image {
                self.image = image
            } else {
                let url = URL(string: urlString)
                let resource = ImageResource(downloadURL: url!, cacheKey: urlString)
                self.kf.setImage(with: resource)
            }
        }
    }
    
}
//  func load(url: URL) {
//
//    print("#1 count", imageCache.count)
//
//    guard imageCache[url.absoluteString] == url else {
//      imageCache[url.absoluteString] = url
//
//      print("#2 캐시 X, 이미지 로드 중")
//      DispatchQueue.global().async { [weak self] in
//        if let data = try? Data(contentsOf: url) {
//          if let image = UIImage(data: data) {
//            DispatchQueue.main.async {
//              self?.image = image
//            }
//          }
//        }
//      }
//      return
//    }
//
//
//
//    DispatchQueue.global().async { [weak self] in
//      print("#3 캐시 O, 저장된 이미지 로드")
//      if let data = try? Data(contentsOf: imageCache[url.absoluteString]!) {
//        if let image = UIImage(data: data) {
//          DispatchQueue.main.async {
//            self?.image = image
//          }
//        }
//      }
//    }
//  }
//}
