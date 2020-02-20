//
//  CadastroWireFrame.swift
//  Closer
//
//  Created by macbook-estagio on 20/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//


import UIKit


class CadastroWireFrame : CadastroWireFrameProtocol {
    var controller : CadastroCategoriaView!
    
    func pushToCadastroCategoria(view: UIViewController) {
        print("indo para cadastro de categoria... ")
        if let navigation = view.navigationController {
            self.controller = CadastroCategoriaView()
            //            let cadastroView = self.controller
            CadastroCategoriaWireFrame.createCadastroCategoriaModulo(viewRef: self.controller)
            navigation.pushViewController(self.controller, animated: true)
        }
    }

    
    
    class func createCadastroModulo(viewRef: CadastroView) {
        let presenter: CadastroPresenterProtocol /*& CloserOutputInteractorProtocol*/ = CadastroPresenter()
        viewRef.presenter = presenter
        viewRef.presenter?.view = viewRef
        viewRef.presenter?.wireframe = CadastroWireFrame()
        viewRef.presenter?.interactor = CadastroInterector()
        viewRef.presenter?.interactor?.presenter = presenter as? CadastroOutputInteractorProtocol
    }
    
    func pushToCloserView(view : UIViewController) {
        if let navigation = view.navigationController {
            //POPULANDO O ARRAYDEPINS
//            CloserView().arrayDePinsDoBanco = LocaisDAO().retrievePlaces()
            navigation.pushViewController(CloserView(), animated: true)
        }
    }
    
    
    deinit {
        print("removeu")
    }
    
    
    
}
