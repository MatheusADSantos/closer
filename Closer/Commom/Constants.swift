//
//  Constants.swift
//  Closer
//
//  Created by macbook-estagio on 25/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    
    static let heigthComponent = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(40) : CGFloat(50)
    static let margin = UIDevice.current.userInterfaceIdiom == .phone ? CGFloat(10) : CGFloat(15)
    
}


extension UIColor {
    
    static let backgroundColorGray7 = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
    static let backgroundColorGray6 = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
    static let backgroundColorGray5 = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1)
    static let backgroundColorGray4 = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1)
    static let backgroundColorGray3 = UIColor(red: 72/255, green: 72/255, blue: 74/255, alpha: 1)
    static let backgroundColorGray2 = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
    static let backgroundColorGray = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
    
}
