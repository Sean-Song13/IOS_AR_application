//
//  ViewController.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/10/24.
//

import UIKit
import RealityKit
import ARKit
import FocusEntity

class ViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var arView: MyARView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var isPlacementEnabled = false {
        didSet{
            if isPlacementEnabled {
                cancelButton.isHidden = false
                checkButton.isHidden = false
                collectionView.isHidden = true
            }else{
                cancelButton.isHidden = true
                checkButton.isHidden = true
                collectionView.isHidden = false
            }
        }
        
    }
    var modelNames:[String] = ["gramophone", "toy_biplane","tv_retro", "teapot"]
    var models:[Model] = []
    var modelConfirmedForPlacement:Model?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(checkPressed), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 25
        checkButton.layer.cornerRadius = 25
        if !isPlacementEnabled {
            cancelButton.isHidden = true
            checkButton.isHidden = true
        }
        arView.setup()
        arView.enableObjectRemoval()
        
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal, .vertical]
//        config.environmentTexturing = .automatic
//        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
//            config.sceneReconstruction = .mesh
//        }
//        arView.session.run(config)
        
        initModels()
        // Load the "Box" scene from the "Experience" Reality File
        //let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        //arView.scene.anchors.append(boxAnchor)
    }
    
    func initModels(){
        for modelname in modelNames{
            let model = Model(modelName: modelname)
            models.append(model)
        }
    }
    
    @objc func cancelPressed(sender: UIButton!) {
        isPlacementEnabled = false
        modelConfirmedForPlacement = nil
            print("cancel Pressed")
    }
    @objc func checkPressed(sender: UIButton!) {
        isPlacementEnabled = false
        guard let model = modelConfirmedForPlacement else {
            return
        }
        // Place a model
//        let filename = modelName + ".usdz"
//        let modelEntity = try! ModelEntity.loadModel(named: filename)
//        if let modelEntity = model.modelEntity {
//            let anchorEntity = AnchorEntity(plane: .any)
//            let modelCloned = modelEntity.clone(recursive: true)
//            modelCloned.generateCollisionShapes(recursive: true)
//            arView.installGestures([.rotation,.translation,.scale], for: modelCloned)
//            anchorEntity.addChild(modelCloned)
//            arView.scene.addAnchor(anchorEntity)
//            print("check Pressed")
//        } else{
//            print("DEBUG: Unable to load modelEntity for \(model.modelName)")
//        }
        
        // Place an image
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.name = model.modelName
        let mesh = MeshResource.generatePlane(width: 1, height: 1)
        var material = SimpleMaterial()
        material.baseColor = try! MaterialColorParameter.texture(TextureResource.load(named: model.modelName))
        material.roughness = MaterialScalarParameter(floatLiteral: 0.5)
        material.metallic = MaterialScalarParameter(floatLiteral: 0.5)
        let planeEntity = ModelEntity(mesh: mesh, materials: [material])
        planeEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation,.translation,.scale], for: planeEntity)
        anchorEntity.addChild(planeEntity)
        arView.scene.addAnchor(anchorEntity)
    }
    
}

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "m_model", for: indexPath) as! ModelCell
        cell.imageView.image = models[indexPath.row].image
        cell.imageView.layer.cornerRadius = 12
        return cell
    }
    
}

extension ViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isPlacementEnabled = true
        modelConfirmedForPlacement = models[indexPath.row]
        print("selected: \(models[indexPath.row])")
    }
}
