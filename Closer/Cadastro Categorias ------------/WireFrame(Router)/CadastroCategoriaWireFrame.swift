//
//  CadastroCategoriaWireFrame.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

class CadastroCategoriaWireFrame: CadastroCategoriaWireFrameProtocol {
    var controller : CadastroView!
    
    
    static func createCadastroCategoriaModulo(viewRef: CadastroCategoriaView) {
        let presenter: CadastroCategoriaPresenterProtocol & CadastroCategoriaOutputInteractorProtocol = CadastroCategoriaPresenter()
        
        viewRef.presenter = presenter
        viewRef.presenter?.view = viewRef
        viewRef.presenter?.wireframe = CadastroCategoriaWireFrame()
        
        viewRef.presenter?.interactor = CadastroCategoriaInterector()
        viewRef.presenter?.interactor?.presenter = presenter //as! CadastroCategoriaOutputInteractorProtocol
    }
    
    func backToCadastroView(view: UIViewController) {
        print("voltando a tela de cadastro...")
        if let navigation = view.navigationController {
//            CadastroView().informacaoDasCategorias = CategoriasDAO().retrieveCategorys()
            navigation.popViewController(animated: true)
        }
    }
    
    

}
