//
//  UIView+Extension.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/23.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  static var reuseIdentifier: String {
      let nameSpaceClassName = NSStringFromClass(self)
      guard let className = nameSpaceClassName.components(separatedBy: ".").last else {
          return nameSpaceClassName
      }
      return className
  }
}
