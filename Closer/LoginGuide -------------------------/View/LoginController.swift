//
//  LoginGuideView.swift
//  Closer
//
//  Created by macbook-estagio on 27/12/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Lottie

protocol  LoginControllerDelegate: class{
    func finishLoggingIn(email: String, senha: String)
}

class LoginController : UIViewController, LoginControllerDelegate, UITextFieldDelegate {
    
    override func loadView() {
        super.loadView()
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.title = "Tutorial"
        registerCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        hideKeyboardTapped()
        observeKeyboardNotification()

        loadingSplash()
//            loadingViews()
        }
    
    var boleano : Bool?
    let cellId = "cellID"
    let loginCellID = "loginCellID"
    
    lazy var pages : [Page] = {
        let first = Page(title: "Mapa", message: "Aqui será mostrado sua localização atual no mapa, com isso, basta escolher o lugar de sua preferencia e segurar precionado em cima do local, assim sendo redirecionado a tela de Cadastro de Marker", imageName: "pag1")
        let second = Page(title: "Cadastro", message: "Aqui você cadastra algumas informações referente ao local, como foto, nome, telefone, site e categoria que melhor se enquadra o lugar ... Caso não exista uma categoria apropriada basta clicar no mais(+) que será redirecionado a tela de Cadastro de Categoria", imageName: "pag2")
        let third = Page(title: "Cadastro de Categoria", message: "Aqui você descreve o nome da categoria que queira cadastrar e a imagem que melhor a representa...", imageName: "pag3")
        let fourth = Page(title: "Marker Cadastrado", message: "Após ter clicado no botão Cadastrar, retornará ao mapa com o Marker redimensionado no exato local com as devidas informações, podendo ser acessadas ao clicar no 'balãozinho' ... ", imageName: "pag4")
        let fifth = Page(title: "Marker Cadastrado", message: "Ao clicar no menu do marker, aparecerá um 'pop-up' com opções de entrar em contato com o local ...", imageName: "pag5")
        let sixth = Page(title: "Menu", message: "Entre em contato com o local pelo telefone ou site", imageName: "pag6")
        let seventh = Page(title: "Excluíndo Categoria", message: "Ao segurar precisonado em alguma categoria, você estará ativando o modo de exclusão.", imageName: "pag7")
        let eighth = Page(title: "Excluindo Categoria", message: "Depois de ativado o modo de exclusão, basta arrastar o icone da categoria até a lixeira, e, soltar em cima dela, com isso você excluirá todos os markers cadatrados com aquela categoria, e caso não seje uma categoria default, a própria categoria será excluída.", imageName: "pag8")
//        let last = Page(title: "Entrando", message: <#T##String#>, imageName: <#T##String#>)
        return [first, second, third, fourth, sixth, seventh, eighth]
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
        return animation
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.backgroundColorGray
        cv.isPagingEnabled = true
        return cv
    }()
    lazy var buttonSkip : UIButton = {
        let bt = UIButton()
        bt.setBasicButton(title: "Skip", font: 18, backgroundColor: .clear, tintColor: .black, cornerRadius: 10)
        bt.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return bt
    }()
    @objc func skip() {
//        if let navigation = navigationController {
//            navigation.pushViewController(CloserView(), animated: true)
//        }
        pageControl.currentPage = pages.count - 1
        nextPag()
    }
    lazy var buttonNext : UIButton = {
        let bt = UIButton()
        bt.setBasicButton(title: "Next", font: 18, backgroundColor: .clear, tintColor: .black, cornerRadius: 10)
        bt.addTarget(self, action: #selector(nextPag), for: .touchUpInside)
            return bt
        }()
         
    @objc func nextPag() {
        if pageControl.currentPage == pages.count {
            return
        }
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOfScreen()
        }
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.pages.count
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .yellow
        return pc
    }()
    
    //MARK: - keyboard Did Show Notification
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardShow() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            self.collectionView.backgroundColor = UIColor.backgroundColorGray7
        }, completion: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.collectionView.backgroundColor = UIColor.backgroundColorGray
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        print("Page Number:", pageNumber)
        pageControl.currentPage = pageNumber
        
//        ..........  Ou uso assim ..........
        
        if pageNumber == pages.count {
            moveControlConstraintsOfScreen()
        } else {
            pageControlBottomAnchor?.constant = -10
            skipButtonTopAnchor?.constant = 20
            nextButtonTopAnchor?.constant = 20
        }
        
//        ..........  Ou uso assim  ..........
        
//        if pageNumber == 1 {
//            pageControl.transform = CGAffineTransform(translationX: 0, y: 20)
//        } else {
//            pageControl.transform = CGAffineTransform.identity
//        }
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func moveControlConstraintsOfScreen() {
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
    }
    
    
    func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellID)
    }
    func loadingSplash() {
        view.addSubviews(viewsToAdd: splashAnimation, labelCloser)
        labelCloser.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(CGFloat.margin*2)
            make.centerX.equalToSuperview()
        }
        splashAnimation.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
        splashAnimation.play { (boleano) in
            print(boleano)
            self.splashAnimation.alpha = 0
            self.loadingViews()
        }
    }
    
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    func loadingViews() {
        view.addSubviews(viewsToAdd: collectionView, buttonSkip, buttonNext, pageControl)
        
        collectionView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
//            make.center.equalToSuperview()
//            make.top.equalToSuperview().offset(64)
//            make.left.right.bottom.equalToSuperview()
        }
//        buttonSkip.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(CGFloat.margin)
//            make.top.equalToSuperview().offset(CGFloat.margin*3)
//            make.width.height.equalTo(50)
//        }
//        buttonNext.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-CGFloat.margin)
//            make.top.equalToSuperview().offset(CGFloat.margin*3)
//            make.width.height.equalTo(50)
//        }
//        pageControl.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-CGFloat.margin*2)
//        }
        
        pageControlBottomAnchor = pageControl.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        skipButtonTopAnchor = buttonSkip.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: CGFloat.margin*3, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        nextButtonTopAnchor = buttonNext.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: CGFloat.margin*3, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
    }
    
    func finishLoggingIn(email: String, senha: String) {
        if email == "Matheus" && senha == "123" {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            guard let mainNavigationController = rootViewController as? MainNavigationController else {return}
            mainNavigationController.viewControllers = [CloserView()]

            UserDefaults.standard.setIsLoggedIn(value: true)

            dismiss(animated: true, completion: nil)
        } else if (email != "" && senha != "") && (email != "Matheus" || senha != "123") {
            if let alerta = Notificacoes().alertaDeLoginErrado() {
                UIApplication.shared.keyWindow?.rootViewController?.present(alerta, animated: true, completion: {
                    print("Deu certo")
                })
            }
            UserDefaults.standard.setIsLoggedIn(value: false)
            return
        }
    }
    
    
}


extension LoginController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellID, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        let page = pages[indexPath.row]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    
    
}
