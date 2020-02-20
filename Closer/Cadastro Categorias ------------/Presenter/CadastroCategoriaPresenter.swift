//
//  CadastroCategoriaPresenter.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit


class CadastroCategoriaPresenter : CadastroCategoriaPresenterProtocol {
    var interactor: CadastroCategoriaInputInteractorProtocol?
    weak var view: CadastroCategoriaViewProtocol?
    var wireframe: CadastroCategoriaWireFrameProtocol?
    
    func viewDidLoad() {
        view?.loadViews()
    }
    
    func registerCategory(categoria: CATEGORIA, viewRef: UIViewController) {
        interactor?.registerCategoryInBank(categoria: categoria, viewRef: viewRef)
    }
    
    
}

extension CadastroCategoriaPresenter : CadastroCategoriaOutputInteractorProtocol {

    func backToCadastroPin(viewRef: UIViewController) {
        print("\nVoltando a tela CadastroPin, depois de salvar no banco...")
        wireframe?.backToCadastroView(view: viewRef)
    }


}

