//
//  ARViewController.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/15.
//

import UIKit
import ARKit
import RealityKit

class ARViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var arView: MyARView!
    @IBOutlet weak var galleryButton: UIButton!
    var modelConfirmedForPlacement:String?
    private var isPlacementEnabled = false {
        didSet{
            if isPlacementEnabled {
                cancelButton.isHidden = false
                checkButton.isHidden = false
                galleryButton.isHidden = true
            }else{
                cancelButton.isHidden = true
                checkButton.isHidden = true
                galleryButton.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isPlacementEnabled {
            cancelButton.isHidden = true
            checkButton.isHidden = true
        }
        galleryButton.layer.cornerRadius = 25
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(checkPressed), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 25
        checkButton.layer.cornerRadius = 25
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetModelForPlacement(_:)), name: Notification.Name("modelSelected"), object: nil)
        arView.setup()
        arView.enableObjectRemoval()
        // Do any additional setup after loading the view.
    }
    
    @objc func didGetModelForPlacement(_ notification: Notification){
        let name = notification.object as! String?
        modelConfirmedForPlacement = name
        isPlacementEnabled = true
    }
    
    @IBAction func OpenGallery(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let galleryViewController = mainStoryboard.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else {
            print("Couldn't find the GalleryViewController")
            return
        }
        present(galleryViewController, animated: true, completion: nil)
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
        
//         Place an image
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.name = model
        let mesh = MeshResource.generatePlane(width: 1, height: 1)
        var material = SimpleMaterial()
        material.baseColor = try! MaterialColorParameter.texture(TextureResource.load(named: model))
        material.roughness = MaterialScalarParameter(floatLiteral: 0.5)
        material.metallic = MaterialScalarParameter(floatLiteral: 0.5)
        let planeEntity = ModelEntity(mesh: mesh, materials: [material])
        planeEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation,.translation,.scale], for: planeEntity)
        anchorEntity.addChild(planeEntity)
        arView.scene.addAnchor(anchorEntity)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


