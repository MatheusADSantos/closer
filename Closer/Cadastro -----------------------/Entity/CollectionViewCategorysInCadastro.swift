//
//  CollectionViewCategorysInCadastro.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit
import SnapKit

final class CollectionViewCategorysInCadastro: UICollectionViewCell {
    
    
//    let viewToTouch : UIView = {
//        let view = UIView()
//        view.backgroundColor = .blue
//        return view
//    }()
    let imageView : UIImageView = {
        let image = UIImageView()
//        image.layer.masksToBounds = true
//        image.setShadow(view: image/*(image as? UIView)!*/, alpha: 0.5, offSetX: -15, offSetY: 15, shadowOpacity: 0.5, shadowRadius: 20, boolean: true)
        image.layer.cornerRadius = CGFloat.heigthComponent/2
        return image
    }()
    let label : UILabel = {
        let label = UILabel()
        label.setBasicLabel(text: "Categoria", textColor: UIColor.backgroundColorGray4,
                            font: 18, backgroundColor: .clear, textAlignment: .left)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        contentView.addSubview(viewToTouch)
//        viewToTouch.snp.makeConstraints { (make) in
//            make.left.right.top.bottom.equalToSuperview()
//        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(CGFloat.heigthComponent)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.height.equalTo(15)
//            make.top.equalTo(imageView.snp.bottom).offset(-3)
//            make.left.equalToSuperview().offset(-5)
//            make.right.equalToSuperview().offset(5)
            make.left.equalTo(imageView.snp.right).offset(CGFloat.margin*2)
            make.centerY.equalTo(imageView)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ////    MARK: - Setando os objetos do CoreData nos itens da CollectionView...
    //    func configuraItem(marker : Array<Locais>) {
    //        print("Resultado --- \([marker])")
    //
    //        for local in marker {
    //            labelCidadeResult.text = local.cidade
    //            guard let estado = local.estado else {return}
    //            labelEstadoResult.text = " (\(String(describing: estado)))"
    //            labelCepResult.text = local.cep
    //            labelLogradouroResult.text = local.logradouro
    //            labelBairroResult.text = local.bairro
    //
    //        }
    
}
