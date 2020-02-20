//
//  MarkerView.swift
//  Closer
//
//  Created by macbook-estagio on 10/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import MapKit
import SnapKit
import UIKit

class CustomMarkerAnnotationView: MKMarkerAnnotationView {
    var telefone: String?
    var site: String?
    static var descricao: String?
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Pino else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            markerTintColor = artwork.markerTintColor
            glyphImage = artwork.markerIcon
            
            self.telefone = artwork.telefone
            self.site = artwork.site
            //            CustomMarkerAnnotationView.telefone = artwork.
            
            //INSTANCIANDO IMAGEM
            let image = UIImageView(image: artwork.image)
            //CONSTRAINTS
            image.snp.makeConstraints { (make) in
                make.height.width.equalTo(80)
            }
            //ADICIONANDO O COMPONENTE AO CENTRO DO CALLOUT...
            detailCalloutAccessoryView = image
            
            //INSTANCIANDO BOTAO
            let buttonToMenu = UIButton(type: .detailDisclosure)
            buttonToMenu.setImage(UIImage(named: "menu"), for: .normal)
            buttonToMenu.addTarget(self, action: #selector(showActionSheet(_:)), for: .touchUpInside)
            //ADICIONANDO O COMPONENTE A DIREITA DO CALLOUT...
            rightCalloutAccessoryView = buttonToMenu
        }
    }
    
    @objc func showActionSheet(_ sender: UIButton) {
        guard let telefone = self.telefone else {return}
        guard let site = self.site else {return}
        if let menu = Notificacoes().mostraMenuDeOpcoes(telefone: telefone, site: site) {
            UIApplication.shared.keyWindow?.rootViewController?.present(menu, animated: true, completion: nil)
        }
    }
    
    
    
    
}
