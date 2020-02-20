//
//  Place.swift
//  Closer
//
//  Created by macbook-estagio on 27/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation

struct Place {
    var descricao: String!
    var telefone: String!
    var site: String!
    
    init(attributes: [String: String]) {
        self.descricao = attributes["descricao"]
        self.telefone = attributes["telefone"]
        self.site = attributes["site"]
    }
}
