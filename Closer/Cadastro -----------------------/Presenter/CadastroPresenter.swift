//
//  CadastroPresenter.swift
//  Closer
//
//  Created by macbook-estagio on 20/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit


class CadastroPresenter : CadastroPresenterProtocol {
    
    var interactor: CadastroInputInteractorProtocol?
    weak var view: CadastroViewProtocol?
    var wireframe: CadastroWireFrameProtocol?
    
    func viewDidLoad() {
        view?.loadViews()
    }
    
    func acessCamera(viewController: UIViewController) {
        print("\nChamando a View para acessar a camera ...")
        view?.showCamera(viewController: viewController)
    }
    
    func registerMarker(dictionary: [String : Any], descricao: String, telefone: String, site: String, view: UIViewController) {
        print("\nCahamando o Interector para salvar dados no CoreData ...")
        interactor?.registerMarkerToCoreData(dictionary: dictionary, descricao: descricao, telefone: telefone, site: site, view: view)
    }
    
    func pushToCadastroCategoria(view: UIViewController) {
        wireframe?.pushToCadastroCategoria(view: view)
    }

}

extension CadastroPresenter : CadastroOutputInteractorProtocol {
    
    func getDataFromCoreData(view: UIViewController) {
        print("\nPegando dados do CoreData ...")
        wireframe?.pushToCloserView(view: view)
    }
    
    
    func acessedCamera(viewController: UIViewController) {
        print("output")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let multimidia = UIImagePickerController()
            multimidia.sourceType = .camera
            UIViewController().present(multimidia, animated: true, completion: nil)
        }
    }
    
    
}
