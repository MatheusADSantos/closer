//
//  Pino.swift
//  Closer
//
//  Created by macbook-estagio on 25/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class Pino: NSObject, MKAnnotation {
    
    let title: String?
    let telefone: String?
    let site: String?
    let coordinate: CLLocationCoordinate2D
    let color: UIColor?
    var icon: UIImage?
    let image: UIImage?
    let idCategoria: String?
    
    var informacaoDosLocais: [Locais] = []
    let arrayDeCategorias: [Categorias] = CategoriasDAO().retrieveCategorys()
    
    
    init(title: String,telefone: String, site: String, coordinate:CLLocationCoordinate2D, color: UIColor?, icon: UIImage?, image: UIImage?, idCategoria: String?) {
        self.title = title
        self.telefone = telefone
        self.site = site
        self.coordinate = coordinate
        self.color = color
        self.icon = icon
        self.image = image
        self.idCategoria = idCategoria
        
        super.init()
    }
    
    var id: String? {
        return idCategoria
    }
    
    var subtitle: String? {
        return title
    }
    
    
    var markerTintColor: UIColor  {
        switch title {
        case "Eu":
            return .black
        default:
            return .purple
        }
    }
    
//    var markerIcon: UIImage  {
//        switch title {
//        case "Eu":
//            return UIImage(named: "man-user")!
//        default:
//            return UIImage(named: "pin")!
//        }
//    }
    
//    let iconImage: UIImage?
    
    func pegaIcon() -> UIImage? {
//        let iconImage: UIImage?
        for pin in informacaoDosLocais {
            let idCategoriaPin = pin.idCategoria
            print("id dos pins \(String(describing: idCategoriaPin))")
            for cat in arrayDeCategorias {
                let idCategoria = String(cat.id!.uuidString)
                print("id das categorias \(idCategoria)")
                if idCategoria == idCategoriaPin {
//                    guard let iconImage = UIImage(data: cat.categoria!) else {return nil}
                    self.icon = UIImage(data: cat.categoria!)
                    
                }
            }
        }
        return icon
    }
    
    var markerIcon: UIImage  {
        switch title {
        case "Eu":
            return UIImage(named: "man-user")!
        default:
            return pegaIcon() ?? UIImage(named: "pin")!
        }
    }

    
    
//    lazy var markerIcon: UIImage = {
//
//
//
//    }()
    
    
    
    
    
//    // Annotation right callout accessory opens this mapItem in Maps app
//    func mapItem() -> MKMapItem {
//        let addressDict = [CNPostalAddressStreetKey: title!]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = title
//        return mapItem
//    }
    
    
    
    
}
