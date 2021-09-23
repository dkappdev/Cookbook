//
//  UILabel+LabelHeight.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 23.09.2021.
//

import UIKit

extension UILabel {
    /// Calculates label height for specified font
    /// - Parameter font: the font used for the text
    /// - Returns: intrinsic label height for specified font
    public static func labelHeight(for font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude)
        let areaBoundingBox = "Label".boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return areaBoundingBox.height
    }
}
