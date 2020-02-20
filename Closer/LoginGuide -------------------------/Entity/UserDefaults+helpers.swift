//
//  UserDefaults+helpers.swift
//  Closer
//
//  Created by macbook-estagio on 04/01/20.
//  Copyright © 2020 macbook-estagio. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case caseisLoggingIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.caseisLoggingIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.caseisLoggingIn.rawValue)
    }
    
}
