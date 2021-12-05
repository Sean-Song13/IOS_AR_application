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

    var currentUser: TagShareServer.User?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
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
    
    var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("worldMapURL")
        } catch {
            fatalError("Error getting world map URL from document directory.")
        }
    }()
    
    
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("Save scene button pressed.")
         
        arView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                print("Unable to get worldMap: \(error!.localizedDescription)")
                return
            }
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
                try data.write(to: self.worldMapURL, options: [.atomic])
                print("map saved")
                print(self.worldMapURL)
                
                UIGraphicsBeginImageContext(self.arView.frame.size)
                self.arView.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                ///UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                let imageData = image?.pngData()
                
                self.upload(data: imageData!, mapData: data)
                
                print(imageData!)
                
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
        
    }
    
    func upload(data: Data, mapData: Data) {
        let tagShareServer = TagShareServer()
        // 添加artSet
        let NewartSet = TagShareServer.ArtSet(artName: "111", mapData: mapData)

       
        // 测试上传所用的Data，实际操作时直接从相册中上传单个data即可
        
        
        if let currentUser = TagShareServerTestViewController.currentUser {
            //上传
            tagShareServer.addOneRecord(user: currentUser, artSet: NewartSet, data: data) { (user) in
                if let newUser = user {
                    print("上传成功")
                    self.currentUser = newUser
                    
                } else {
                    print("上传失败")
                }
            }
        }
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        print("Load scene button pressed")
        
        // 从userSet取ARWorldMapURL
        let tagShareServer = TagShareServer()
        tagShareServer.downLoadAllUsers() { (userSet) in
            if let userSet = userSet {
                print("获取成功")
                print(userSet)
                for user in userSet {
                    for art in user.artSets {
                        let map = art.mapData
                        print(map)
                        
                        
                        //guard let mapData = try? Data(contentsOf: map) else { fatalError("No ARWorldMap in archive. ") }
                        let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: map)
                                
                        let configuration = ARWorldTrackingConfiguration()
                        
                        configuration.planeDetection = [.horizontal, .vertical]
                                
                        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
                        configuration.initialWorldMap = worldMap
                        print("map loading")

                        self.arView.debugOptions = [.showFeaturePoints]
                        self.arView.session.run(configuration, options: options)
                        
                    }
                }
            } else {
                print("获取失败")
            }
        }
        
        
    }
    
    

}


