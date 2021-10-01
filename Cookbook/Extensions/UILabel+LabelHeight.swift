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
    
    /// Calculates label height with specified width
    /// - Parameter font: the font used for the text
    /// - Parameter width: width to use for calculations
    /// - Parameter text: text used to calculate height
    /// - Returns: intrinsic label height for specified fonts
    public static func labelHeight(for font: UIFont, withText text: String, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let areaBoundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return areaBoundingBox.height
    }
}
