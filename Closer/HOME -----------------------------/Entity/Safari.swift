//
//  Safari.swift
//  Closer
//
//  Created by macbook-estagio on 08/11/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit
import SafariServices


class Safari : NSObject {
    
    func abrePaginaWeb(site: String) {
        var urlFormatada = site
        if !urlFormatada.hasPrefix("http://") {
            urlFormatada = String(format: "http://%@", urlFormatada)
        }
        
        guard let url = URL(string: urlFormatada) else { return }
        let safariViewController = SFSafariViewController(url: url)
        UIApplication.shared.keyWindow?.rootViewController?.present(safariViewController, animated: true, completion: nil)
    }
    
    
}
