//
//  Model.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/13.
//

import UIKit
import RealityKit
import Combine

class Model{
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename).sink(receiveCompletion: { loadCompletion in
//            print("DEBUG: load model \(self.modelName) failed")
        }, receiveValue: { modelEntity in
            self.modelEntity = modelEntity
            print("DEBUG: successfully loaded: \(self.modelName)")
        })
        
    }
}


