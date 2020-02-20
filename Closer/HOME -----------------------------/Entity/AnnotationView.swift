//
//  AnnotationViewCell.swift
//  Closer
//
//  Created by macbook-estagio on 09/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//
import UIKit
import SnapKit
import MapKit

//final class AnnotationView : MKAnnotationView {
//    
//    
//
//    //MARK: - Criando Componentes
//    lazy var labelInfoPin : UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .white
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        label.setBasicLabel(text: "...", textColor: .red, font: UIFont.systemFont(ofSize: 10), backgroundColor: .red, textAlignment: .left)
//        return label
//    }()
//    lazy var imageViewPin : UIImageView = {
//        let image = UIImageView()
//        image.layer.cornerRadius = 10
//        image.layer.masksToBounds = true
//        return image
//    }()
//
//
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        canShowCallout = true
//        calloutOffset = CGPoint(x: -5, y: 5)
//        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        setupViews()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//
//
//        leftCalloutAccessoryView?.addSubview(labelInfoPin)
//
//
////        //Add label in Cell
////        addSubview(labelInfoPin)
////        addSubview(imageViewPin)
//
//
//        //Add Constraints
//        labelInfoPin.snp.makeConstraints { (make) in
//            make.height.equalTo(25)
////            make.left.top.equalTo(imageViewPin.snp.right).offset(2)
//            make.left.top.equalToSuperview().offset(2)
////            make.right.equalToSuperview().offset(-2)
//        }
//
////        imageViewPin.snp.makeConstraints { (make) in
////            make.left.top.equalToSuperview().offset(2)
////            make.bottom.equalToSuperview().offset(-2)
////            make.width.equalTo(100)
////        }
//
//
////    }
//
//
//
////    //MARK: - Setando os dados da request nas labels da cell, através do CoreData ...
////    func configuraCelula(_ local : Array<Locais>) {
////        print("Resultado --- \([local])")
////
////        for local in local {
////            labelCidadeResult.text = local.cidade
////            guard let estado = local.estado else {return}
////            labelEstadoResult.text = " (\(String(describing: estado)))"
////            labelCepResult.text = local.cep
////            labelLogradouroResult.text = local.logradouro
////            labelBairroResult.text = local.bairro
////
////        }
////
////    }
//
//
//}
//
//
//
//
//
//
////import MapKit
////
////class AnnotationViewCell: MKMarkerAnnotationView {
////    override var annotation: MKAnnotation? {
////        willSet {
////            // 1
////            guard let artwork = newValue as? AnnotationViewCell else { return }
////
////            canShowCallout = true
////            calloutOffset = CGPoint(x: -5, y: 5)
////            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
////            // 2
////            markerTintColor = artwork.markerTintColor
////            glyphText = String("uhsauhsauushsa")
////
//////            artwork.glyphImage = annotation.icon
//////            artwork.markerTintColor = annotation.color
////            artwork.glyphTintColor = .red
////            artwork.glyphText = "kakakkaka"
////        }
////    }
//
//
//}



import MapKit

class AnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? AnnotationView else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)



//            if let imageName = artwork.imageName {
//                image = UIImage(named: imageName)
//            } else {
//                image = nil
//            }
        }
    }
}
