//
//  UIColor+HexString.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/19/24.
//

import UIKit

extension UIColor {
    // 에러 타입 정의
    enum ColorError: Error {
        case unableToExtractRGBComponents
    }

    /// RGB 컴포넌트를 Hex 문자열로 변환
    private func rgbToHexValue() throws -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            throw ColorError.unableToExtractRGBComponents
        }

        return String(format: "#%02lX%02lX%02lX",
                      lround(Double(red * 255)),
                      lround(Double(green * 255)),
                      lround(Double(blue * 255)))
    }

    /// Hex 문자열로 변환
    func hexValue() -> String {
        do {
            return try rgbToHexValue()
        } catch {
            return "#00925BFF"  // 시그니처 컬러
        }
    }
}
