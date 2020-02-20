//
//  CadastroCategorysInteractorProtocol.swift
//  Closer
//
//  Created by macbook-estagio on 16/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

class CadastroCategoriaInterector: CadastroCategoriaInputInteractorProtocol {
    
    var presenter: CadastroCategoriaOutputInteractorProtocol?
    var lugar : [Categorias] = []
    var local:Categorias?
    
    
    func registerCategoryInBank(categoria: CATEGORIA, viewRef: UIViewController) {
//        print("\nVoltando a tela direto!!!\n")
//        presenter?.backToCadastroPin(viewRef: viewRef)
        
        print("\nInterector Tratou os dados, Salvou no Banco e Chamou o Presenter(InteractorOutPut)!!!\n")
        let validaDescricao = CategoriasDAO().salvaCategoria(descricao: categoria.descricao, categoria: categoria.image, viewRef: viewRef)
        if validaDescricao == true {
            print("\nNão tem essa descrição cadastrada ainda -> ... SALVANDO ...")
            print("Salvando Dados no CoreData ... e chamando o presenter para pegar os dados ...")
//            CadastroView().informacaoDasCategorias = CategoriasDAO().retrieveCategorys()
            presenter?.backToCadastroPin(viewRef: viewRef)
        } else {
            print("Já existe")
        }
    }
    
    
}
