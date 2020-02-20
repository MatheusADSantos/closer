//
//  CadastroInterector.swift
//  Closer
//
//  Created by macbook-estagio on 25/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit

class CadastroInterector: CadastroInputInteractorProtocol {
    var presenter: CadastroOutputInteractorProtocol?
    var lugar : [Locais] = []
    var local:Locais?
    
    func registerMarkerToCoreData(dictionary: [String : Any], descricao: String, telefone: String, site: String, view: UIViewController) {
        //O validaDescricao busca no "banco" o metodo de salvar e lá mesmo ele verifica se já existe a descricao cadastrada, se não existe, ele salva
        let validaDescricao = LocaisDAO().salvaLocais(dicionarioDeLocais: dictionary, descricao: descricao, telefone: telefone , site: site, view: view)
        if validaDescricao == true {
            print("\nNão tem essa descrição cadastrada ainda -> ... SALVANDO ...")
            print("Salvando Dados no CoreData ... e chamando o presenter para pegar os dados ...")
            view.delayWithSeconds(0) {
                self.presenter?.getDataFromCoreData(view: view)
            }
        } else {
            print("Já existe")
        }
    }
    

//    weak var presenterIn: CadastroInputInteractorProtocol?
//    weak var presenterOut: CadastroOutputInteractorProtocol?
    

    
    
//    func acessCamera(viewController: UIViewController) {
//        print("presenterInput -> Interector")
////        presenter?.acessedCamera(viewController: viewController)
//    }
    
   
}
