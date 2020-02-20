//
//  MetodosCollection.swift
//  Closer
//
//  Created by macbook-estagio on 18/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


//var informacaoDasCategorias : [Categorias] = CategoriasDAO().retrieveCategorys()

class MetodosColletion : NSObject {
    
    
    //REMOVENDO UM ITEM DA COLLETION
    func removeItemFromColletion(index: Int, collectionView: UICollectionView, view: UIViewController, arrayCategorias: [Categorias] ) {
        print("array de cat: \(arrayCategorias)")
        
        //Feed para o user que foi deletado um item da collection----------------------------------------------
        print("\nFoi removido uma categoria da colletionView")
        let item = arrayCategorias[index]
        guard let categoriaExcluida = item.descricao else {return}
        if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: categoriaExcluida) {
            view.present(alerta, animated: true, completion: nil)
        }
        //Feed para o user que foi deletado um item da collection----------------------------------------------
        
        
        CategoriasDAO().deleteCategoria(categoria: arrayCategorias[index])
//        informacaoDasCategorias.remove(at: index)
//        arrayCategorias.remove(at: index)

        let indexPath = IndexPath(row: index, section: 0)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])


        }, completion: {
            (finished: Bool) in
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        })
    }
    
    
    
    func moveItemAtTo(indexAt: Int, indexTo: Int = 0, collectionView: UICollectionView) {
        let indexPathAt = IndexPath(row: indexAt, section: 0)
        let indexPathTo = IndexPath(row: indexTo, section: 0)
        collectionView.moveItem(at: indexPathAt, to: indexPathTo)
    }
    
    
    
}
