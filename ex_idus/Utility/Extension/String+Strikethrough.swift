//
//  String+Extension.swift
//  ex_idus
//
//  Created by 박근형 on 2020/04/04.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func Strikethrough() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}
