//
//  Font.swift
//  ex_idus
//
//  Created by 박근형 on 2020/04/05.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

struct Font {
    func NotoSansCJKkrBold(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    func NotoSansCJKkrBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Black", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
}
