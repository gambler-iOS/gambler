//
//  UIImage+Extension.swift
//  gambler
//
//  Created by daye on 2/21/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

extension UIImage {
    func resized(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
