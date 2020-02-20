//
//  BootScreen.swift
//  Closer
//
//  Created by macbook-estagio on 23/12/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class BootScreen : UIViewController {
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.backgroundColorGray5
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSplash()
//        Mostando todas as famílias de font...
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font Names: \(names)")
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        labelCloser.center.x = view.center.x // Place it in the center x of the view.
//        labelCloser.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
//        // animate it from the left to the right
//        UIView.animate(withDuration: 4.5, delay: 0, options: [.curveEaseOut], animations: {
//            self.labelCloser.center.x += self.view.bounds.width
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
    
    
    var boleano: Bool?
    
    //MARK: Componentes
    
    let splashView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let splashViewImage : UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "splash")
        img.alpha = 0.2
        return img
    }()
    let labelCloser : UILabel = {
        let lb = UILabel()
        lb.setBasicLabel(text: "Closer", textColor: UIColor().hexaToColor(hex: "48a7d5"), font: 130, backgroundColor: .clear, textAlignment: .center)
        //let family = UIFont.fontNames(forFamilyName: "Charis SIL")
        //lb.font = UIFont(name: family[0], size: 140)
        let family = UIFont.fontNames(forFamilyName: "CRAVA")
        lb.font = UIFont(name: family[0], size: 140)
        return lb
    }()
    lazy var splashAnimation : AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("trajeto4")
//        animation.loopMode = .loop
        animation.animationSpeed = 0.7
        animation.play()
        animation.clipsToBounds = true
        animation.backgroundColor = .clear
        self.boleano = animation.isAnimationPlaying
        
        //                    animation.setPlayRange(fromProgress: 0, toProgress: 0.7, event: .touchUpInside)
        //            animation.addTarget(self, action: #selector(buttonClickedToBookMark(_ :)), for: .touchUpInside)
        return animation
    }()
    lazy var pinAnimation : AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("pin")
        animation.loopMode = .loop
        animation.animationSpeed = 0.7
        animation.backgroundColor = .clear
        animation.alpha = 0
        return animation
        }()
    let labelDescricao : UILabel = {
        let lb = UILabel()
//        let raio = CGFloat.heigthComponent/2
        lb.setBasicLabel(text: """
                                    Closer é uma agenda de lugares, onde o usuário pode salvar sua localização(no mapa) e com isso, criar um cadastro com alguns dados como telefone, site e categoria...



                                Como Funciona:
                                    Ao Clicar no botão Entrar, você será direcionado ao mapa com sua localização atual, com isso, basta escolher o lugar de sua preferencia e segurar precionado em cima do local.
                                    Desta forma aparecerá uma tela de Cadastro onde você entrará com algumas informações, e, por fim é só clicar em Cadastrar e voltará ao mapa.
                                    O Mapa irá redimensionar a fim de mostrar sua localização e de todos os lugares/markers cadastrados ... A partir daí, você será capaz de fazer suas buscas por CATEGORIA ou pelo SEARCH BAR.
                                    Ao achar o marker desejado, basta clicar nele que aparecerá um balãozinho com o nome do lugar a foto e um menu para estar entrando em contato.


                                
                                    Com ele sua busca por seus lugares mais próximo/favoritos se tornará mais fácil através da função 'Closer'.
                                Com apenas dois cliques: 1 - Selecionando a Categoria Desejada e 2 - Clicando no Buscar.

                                
                                """, textColor: .white, font: 16, backgroundColor: .clear, textAlignment: .justified)
        lb.numberOfLines = lb.maxNumberOfLines
        
        
        print("número máximo de linhas necessárias para um rótulo renderizar o texto sem truncamento",lb.maxNumberOfLines,"\nnúmero máximo de linhas pode ser exibido em um rótulo com limites restritos. Use essa propriedade depois de atribuir texto ao rótulo.",lb.numberOfVisibleLines)
        
        return lb
    }()
    let labelAsk : UILabel = {
        let lb = UILabel()
        lb.setBasicLabel(text: "Entendeu ? ...", textColor: .white, font: 20, backgroundColor: .clear, textAlignment: .left)
        return lb
    }()
    let buttonEnter : UIButton = {
        let bt = UIButton()
        bt.setBasicButton(title: " Entrar ", font: 40, backgroundColor: UIColor().hexaToColor(hex: "46a4d1"), tintColor: .black, cornerRadius: 10)
        bt.alpha = 0
        bt.addTarget(self, action: #selector(enterToMap), for: .touchUpInside)
        return bt
    }()
    let buttonKnow : UIButton = {
        let bt = UIButton()
        bt.setBasicButton(title: ">>> SIM <<<", font: 40, backgroundColor: .red, tintColor: .black, cornerRadius: 10)
        bt.addTarget(self, action: #selector(understood), for: .touchUpInside)
        return bt
    }()
    
    @objc func understood () {
        buttonEnter.alpha = 1
        buttonKnow.alpha = 0
        pinAnimation.alpha = 1
        pinAnimation.play()
    }
    
    @objc func enterToMap () {
        if let navigation = navigationController {
            navigation.pushViewController(CloserView(), animated: true)
        }
    }
    
    
    func loadSplash() {
        print("Carregando Splash")
        view.addSubview(splashView)
        splashView.addSubviews(viewsToAdd: labelCloser, splashAnimation)
        
        splashView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        labelCloser.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(CGFloat.margin*2)
            make.centerX.equalToSuperview()
        }
        splashAnimation.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        splashAnimation.play { (boleano) in
            self.splashView.alpha = 0
            self.loadViews()
//            self.navigationController?.isNavigationBarHidden = false
//            self.navigationController?.pushViewController(CloserView(), animated: true)
        }
    }
    
    func loadViews() {
        print("Carregando as Views")
        
        view.addSubviews(viewsToAdd: splashViewImage, labelDescricao, labelAsk, buttonKnow, buttonEnter, pinAnimation)
        
        labelDescricao.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.centerY.equalToSuperview()
        }
        labelAsk.snp.makeConstraints { (make) in
            make.left.equalTo(buttonEnter)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalTo(buttonEnter.snp.top).offset(-CGFloat.margin)
        }
        buttonKnow.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.margin*3)
            make.left.equalToSuperview().offset(CGFloat.margin*3)
            make.right.equalToSuperview().offset(-CGFloat.margin*3)
                }
        buttonEnter.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CGFloat.margin*3)
            make.left.equalToSuperview().offset(CGFloat.margin*3)
            make.right.equalToSuperview().offset(-CGFloat.margin*3)
        }
        pinAnimation.snp.makeConstraints { (make) in
            make.centerY.equalTo(buttonEnter)
            make.centerX.equalTo(buttonEnter).offset(60)
            make.height.width.equalTo(100)
        }
        splashViewImage.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        
        
    }
    
    
    
}


extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
        let lineHeight = font.lineHeight
//        return Int(ceil(textHeight / lineHeight))
        return Int((textHeight + lineHeight))
//        return Int(textHeight*lineHeight)
//        return Int(textHeight)
    }

    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
