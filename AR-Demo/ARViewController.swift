//
//  ARViewController.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/15.
//

import UIKit
import ARKit
import RealityKit
import Combine

private let anchorNamePrefix = "model-"

class ARViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager:CLLocationManager?
    
    
    var currentUser: TagShareServer.User?
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var arView: MyARView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
//    var modelNameConfirmed:String?
    var imageTypeConfirmed:ImageType?
    private var cancellable: AnyCancellable? = nil
    private var sceneObserver: Cancellable?
    private var sceneManager:SceneManager?
    private var modelConfirmedForPlacement:[modelInfo] = []
    private var modelWaitForConfirmed:modelInfo?
    private var coorinator:Coordinator?
    
    private var isPlacementEnabled = false {
        didSet{
            if isPlacementEnabled {
                cancelButton.isHidden = false
                checkButton.isHidden = false
                galleryButton.isHidden = true
                uploadButton.isHidden = true
                downloadButton.isHidden = true
            }else{
                cancelButton.isHidden = true
                checkButton.isHidden = true
                galleryButton.isHidden = false
                uploadButton.isHidden = false
                downloadButton.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self

        
        
        if !isPlacementEnabled {
            cancelButton.isHidden = true
            checkButton.isHidden = true
        }
        galleryButton.layer.cornerRadius = 25
        uploadButton.layer.cornerRadius = 25
        downloadButton.layer.cornerRadius = 25
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(checkPressed), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadPressed), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadPressed), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 25
        checkButton.layer.cornerRadius = 25
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetModelForPlacement(_:)), name: Notification.Name("modelSelected"), object: nil)
        
        coorinator = makeCoordinator()
        arView.setup()
        arView.enableObjectRemoval()
        arView.session.delegate = coorinator
        self.sceneManager = SceneManager()
        self.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
            self.updateScene(for : self.arView)
            self.updatePersistenceAvailability(for: self.arView)
        })
        // Do any additional setup after loading the view.
    }
    
    var longi: Double?
    var lati: Double?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            longi = location.coordinate.longitude
            lati = location.coordinate.latitude
        }
          
      }
    
    
    private func updatePersistenceAvailability(for arView: ARView){
        guard let currentFrame = arView.session.currentFrame else {
            print("ARFrame not available")
            return
        }
        
        switch currentFrame.worldMappingStatus {
        case .mapped, .extending:
            let result = !(self.sceneManager?.anchorEntities.isEmpty ?? true)
            self.sceneManager?.isPersistenceAvalible = result
        default:
            self.sceneManager?.isPersistenceAvalible = false
        }
        self.uploadButton.isEnabled = self.sceneManager?.isPersistenceAvalible ?? false
        self.downloadButton.isEnabled = self.sceneManager?.scenePersistenceData != nil
    }
    
    private func updateScene(for arView: MyARView){
        arView.focusEntity?.isEnabled = self.modelWaitForConfirmed != nil
        
        
        guard let confirmedModel = modelConfirmedForPlacement.popLast() else { return }
        
        let modelName = confirmedModel.modelName
        
        if let anchor = confirmedModel.anchor {
            
            placeModel(modelName: modelName, type: confirmedModel.type, anchor: anchor)
            
            arView.session.add(anchor: anchor)
        
        } else if let transform = getTransformForPlacement(in: arView) {
            let modelTypeAndName = confirmedModel.type.label + "-" + modelName
            let anchorName = anchorNamePrefix + modelTypeAndName
            let anchor = ARAnchor(name: anchorName, transform: transform)
            
            placeModel(modelName: modelName, type: confirmedModel.type, anchor: anchor)
            
            arView.session.add(anchor: anchor)
        }
    }
    
    @objc func didGetModelForPlacement(_ notification: Notification){
        let info = notification.object as! modelInfo
        modelWaitForConfirmed = info
//        modelConfirmedForPlacement.append(info)
//        modelNameConfirmed = info.modelName
        imageTypeConfirmed = info.type
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
    
    @objc func uploadPressed(sender: UIButton) {
        if let sceneManager = self.sceneManager{
            ScenePersistenceHelper.saveScene(for: self.arView, at: sceneManager.persistenceUrl)
            
            // screenshot data
            UIGraphicsBeginImageContext(self.arView.frame.size)
            self.arView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let theImage = image
            let imageData = theImage!.pngData()!
            upload(data: imageData, mapUrl: sceneManager.persistenceUrl)
        }
        
    }
    
    func upload(data: Data, mapUrl: URL) {
            let tagShareServer = TagShareServer()
            // 添加artSet
        let NewartSet = TagShareServer.ArtSet(artName: "111", mapUrl: mapUrl, longitude: longi!, latitude: lati!)

           
            // 测试上传所用的Data，实际操作时直接从相册中上传单个data即可
            
            
            if let currentUser = SignInViewController.currentUser {
                //上传
                tagShareServer.addOneRecord(user: currentUser, artSet: NewartSet, data: data) { (user) in
                    if let newUser = user {
                        print("上传成功")
                        //TagShareServerTestViewController.currentUser = newUser
                        self.currentUser = newUser
                        
                    } else {
                        print("上传失败")
                    }
                }
            }
        }
    
    @objc func downloadPressed(sender: UIButton){
        
        // 从userSet取ARWorldMapURL
        let tagShareServer = TagShareServer()
        tagShareServer.downLoadAllUsers() { (userSet) in
            if let userSet = userSet {
                print("获取成功")
                print(userSet)
                for user in userSet {
                    for art in user.artSets {
                        let mapUrl = art.mapUrl
                        print(mapUrl)
                        
                         let mapData = try? Data(contentsOf: mapUrl) //else { fatalError("No ARWorldMap in archive. ") }
                        
                        guard let scenePersistenceData = mapData else {
            print("Unable to retrieve scenePersistenceData. Canceled loadScene operation.")
            return
                        }
                        ScenePersistenceHelper.loadScene(for: self.arView, with: scenePersistenceData)
        
                        self.sceneManager?.anchorEntities.removeAll(keepingCapacity: true)
                    }
                }
            } else {
                print("获取失败")
            }
        }
    }
    
    @objc func cancelPressed(sender: UIButton!) {
        isPlacementEnabled = false
        modelWaitForConfirmed = nil
            print("cancel Pressed")
    }
 
    @objc func checkPressed(sender: UIButton!) {
        isPlacementEnabled = false
        guard let model = modelWaitForConfirmed else {
            return
        }
        modelConfirmedForPlacement.append(model)
//        modelWaitForConfirmed = nil
    
    }
    
    func placeModel(modelName: String, type: ImageType, anchor: ARAnchor){
        // Place a model
        if type == .threeD{
            let filename = modelName + ".usdz"
//            let modelEntity = try? ModelEntity.loadModel(named: filename)
            var modelEntity = ModelEntity()
            self.cancellable = ModelEntity.loadModelAsync(named: filename)
                .sink(receiveCompletion: { loadCompletion in
                    switch loadCompletion{
                    case .failure(let error):
                        print("DEBUG: Unable to load modelEntity for \(filename), Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: {loadedModelEntity in
                    modelEntity = loadedModelEntity
                    print("DEBUG: modelEntity for \(filename) loaded")
                    let anchorEntity = AnchorEntity(plane: .any)
                    let modelCloned = modelEntity.clone(recursive: true)
                    modelCloned.generateCollisionShapes(recursive: true)
                    self.arView.installGestures([.rotation,.translation,.scale], for: modelCloned)
                    anchorEntity.addChild(modelCloned)
                    anchorEntity.anchoring = AnchoringComponent(anchor)
                    self.sceneManager?.anchorEntities.append(anchorEntity)
                    self.arView.scene.addAnchor(anchorEntity)
                })
        }
        
//         Place an image plane
        if type == .standard {
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.name = modelName
            var ratio:Float = 1
            for fileExtension in ["png", "jpg", "jpeg"]{
                if let bundleURL = Bundle.main.url(forResource: modelName, withExtension: fileExtension){
                    if let imageData = try? Data(contentsOf: bundleURL){
                        let image = UIImage(data: imageData)!
                        ratio = Float(image.size.height) / Float(image.size.width)
                    }
                }
            }
            let mesh = MeshResource.generatePlane(width: 1, height: ratio)
            var material = SimpleMaterial()
            material.tintColor = UIColor(white: 1.0, alpha: 0.9999)
            material.baseColor = try! MaterialColorParameter.texture(TextureResource.load(named: modelName))
            material.roughness = MaterialScalarParameter(floatLiteral: 0.5)
            material.metallic = MaterialScalarParameter(floatLiteral: 0.5)
            
            let planeEntity = ModelEntity(mesh: mesh, materials: [material])
            planeEntity.generateCollisionShapes(recursive: true)
            arView.installGestures([.rotation,.translation,.scale], for: planeEntity)
            anchorEntity.addChild(planeEntity)
            anchorEntity.anchoring = AnchoringComponent(anchor)
            self.sceneManager?.anchorEntities.append(anchorEntity)
            arView.scene.addAnchor(anchorEntity)
        }
        
        // Place a GIF image
        if type == .gif {
            let animationHelper = GifAnimationHelper()
            DispatchQueue.global().async {
                animationHelper.saveGifAsPngSequence(gifNamed: modelName)
                DispatchQueue.main.async {
                    let ratio = animationHelper.getAtio()
                    let anchorEntity = AnchorEntity(plane: .any)
                    anchorEntity.name = modelName
                    let mesh = MeshResource.generatePlane(width: 1, height: ratio ?? 1)
                    let planeEntity = ModelEntity(mesh: mesh)
                    planeEntity.generateCollisionShapes(recursive: true)
                    self.arView.installGestures([.rotation,.translation,.scale], for: planeEntity)
                    anchorEntity.addChild(planeEntity)
                    anchorEntity.anchoring = AnchoringComponent(anchor)
                    self.sceneManager?.anchorEntities.append(anchorEntity)
                    self.arView.scene.addAnchor(anchorEntity)
                    animationHelper.playGifAnimation(gifNamed: modelName, modelEntity: planeEntity)
                }
            }
        }

    }
    
    private func getTransformForPlacement(in arView: ARView) -> simd_float4x4?{
        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else { return nil }
        
        guard let raycastResult = arView.session.raycast(query).first else { return nil }
        
        return raycastResult.worldTransform
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

extension ARViewController {
    
    class Coordinator:NSObject, ARSessionDelegate{
        var parent : ARViewController
        
        init(_ parent: ARViewController){
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
                for anchor in anchors {
                    if let anchorName = anchor.name, anchorName.hasPrefix(anchorNamePrefix){
                        if parent.modelWaitForConfirmed == nil{
                            let modelType = anchorName.dropFirst(anchorNamePrefix.count)
                            print("ARSession: didAdd anchor for modelName: \(modelType)")
                        
                            if let index = modelType.firstIndex(of: "-"){
                                let modelName = modelType[index...].dropFirst(1)
                                let typeString = modelType[...index].dropLast(1)
                                var type:ImageType
                                switch typeString {
                                case ImageType.standard.label:
                                    type = ImageType.standard
                                case ImageType.gif.label:
                                    type = ImageType.gif
                                case ImageType.threeD.label:
                                    type = ImageType.threeD
                                default:
                                    fatalError("Error: type parse failed")
                                }
                                let modelInfo = modelInfo(modelName: String(modelName), type: type, anchor: anchor)
                                
                                self.parent.modelConfirmedForPlacement.append(modelInfo)
                                print("Adding modelAnchor with name: \(modelInfo.modelName)")
                            }
                        }
                        else {
                            parent.modelWaitForConfirmed = nil
                        }
                    }
                }
        }
    }
    
    func makeCoordinator() -> Coordinator{
        return Coordinator(self)
    }
    
}

class SceneManager: ObservableObject{
    var isPersistenceAvalible : Bool = false
    var anchorEntities : [AnchorEntity] = []
    lazy var persistenceUrl : URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.persistence")
        } catch{
            fatalError("Unable to get persistenceUrl: \(error.localizedDescription)")
        }
    }()
    
    var scenePersistenceData: Data? {
        return try? Data(contentsOf: persistenceUrl)
    }
}

