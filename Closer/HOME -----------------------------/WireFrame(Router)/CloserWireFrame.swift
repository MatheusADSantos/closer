//
//  CloserWireFrameProtocols.swift
//  Closer
//
//  Created by macbook-estagio on 18/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//


import UIKit

class CloserWireFrame: CloserWireFrameProtocol {
    var controller : CadastroView!
    
    class func createCloserModule(closerViewRef: CloserView) {
        let presenter: CloserPresenterProtocol /*& CloserOutputInteractorProtocol*/ = CloserPresenter()
        
        closerViewRef.presenter = presenter
        closerViewRef.presenter?.view = closerViewRef
        closerViewRef.presenter?.wireframe = CloserWireFrame()
        
//        closerViewRef.presenter?.interactor = CloserInteractor()
//        closerViewRef.presenter?.interactor?.presenter = presenter
    }
    
    
    func pushToCadastroView(viewRef: UIViewController) {
        if let navigation = viewRef.navigationController {
            self.controller = CadastroView()
//            let cadastroView = self.controller
            CadastroWireFrame.createCadastroModulo(viewRef: self.controller)
            navigation.pushViewController(self.controller, animated: true)
        }
    }
    

    
}
