//
//  Extension.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit

extension UIColor {
    
    class var customGray: UIColor? { return UIColor(named: "backColor") }
    class var customOrange: UIColor? { return UIColor(named: "orangeColor")}
    class var customMint: UIColor? { return UIColor(named: "mintColor")}
    class var customSoda: UIColor? { return UIColor(named: "sodaColor")}
    class var customHotPink: UIColor? { return UIColor(named: "hotPinkColor")}
    class var customPink: UIColor? { return UIColor(named: "pinkColor")}
    class var customChocolet: UIColor? { return UIColor(named: "chocoletColor")}
    class var customBaige: UIColor? { return UIColor(named: "baigeColor")}
    class var customPastelGreen: UIColor? { return UIColor(named: "pastelGreenColor")}
    class var customPastelBlue: UIColor? { return UIColor(named: "pastelBlueColor")}
    class var customYellow: UIColor? { return UIColor(named: "yellowColor")}
    class var customPastelPink: UIColor? { return UIColor(named: "pastelPinkColor")}
    class var customLightPuple: UIColor? { return UIColor(named: "lightPupleColor")}
    class var customAhbocado: UIColor? { return UIColor(named: "ahbocadoColor")}
    class var customLacoste: UIColor? { return UIColor(named: "lacosteColor")}
    
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}
