//
//  CloserPresenter.swift
//  Closer
//
//  Created by macbook-estagio on 18/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

class CloserPresenter : CloserPresenterProtocol {
    var interactor: CloserInputInteractorProtocol?
    weak var view: CloserViewProtocol?
    var wireframe: CloserWireFrameProtocol?
    
    func viewDidLoad() {
        print("Carregou a viewDidLoad")
        view?.loadViews()
        view?.showMyLocation()
        view?.additionalConfiguration()
    }
    
    
    func callViewController(viewRef: UIViewController) {
        print("Chamando a tela de Cadastro ...")
        wireframe?.pushToCadastroView(viewRef: viewRef)
    }
    
  
}

extension CloserPresenter: CloserOutputInteractorProtocol {
//    func fetchColor(name: String) {
//        view?.showViews()
//    }
    
    
}
