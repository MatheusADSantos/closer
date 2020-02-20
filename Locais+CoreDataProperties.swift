//
//  Locais+CoreDataProperties.swift
//  
//
//  Created by macbook-estagio on 30/09/19.
//
//

import Foundation
import CoreData


extension Locais {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locais> {
        return NSFetchRequest<Locais>(entityName: "Locais")
    }

    @NSManaged public var descricao: String?
    @NSManaged public var site: String?
    @NSManaged public var telefone: String?

}
