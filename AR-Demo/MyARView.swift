//
//  MyARView.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/14.
//
//
import Combine
import RealityKit
import ARKit
import FocusEntity
//
class MyARView: ARView {
    enum FocusStyleChoices {
        case classic
        case material
        case color
      }

      // Style to be displayed in the example
      let focusStyle: FocusStyleChoices = .classic
      var focusEntity: FocusEntity?
    var defaultConfiguration: ARWorldTrackingConfiguration{
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        return config
    }
      required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setup()
      }

    func setup(){
        self.setupConfig()

        switch self.focusStyle {
        case .color:
          self.focusEntity = FocusEntity(on: self, focus: .plane)
        case .material:
          do {
            let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
            let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
            self.focusEntity = FocusEntity(
              on: self,
              style: .colored(
                onColor: onColor, offColor: offColor,
                nonTrackingColor: offColor
              )
            )
          } catch {
            self.focusEntity = FocusEntity(on: self, focus: .classic)
            print("Unable to load plane textures")
            print(error.localizedDescription)
          }
        default:
          self.focusEntity = FocusEntity(on: self, focus: .classic)
        }
    }
      func setupConfig() {
        session.run(defaultConfiguration)
      }

      @objc required dynamic init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
//        fatalError("init(coder:) has not been implemented")
      }
    }

    extension MyARView: FocusEntityDelegate {
      func toTrackingState() {
        print("tracking")
      }
      func toInitializingState() {
        print("initializing")
      }
    }

extension MyARView{
    func enableObjectRemoval(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(gesture)
    }

    @objc func handleLongPress(_ sender : UILongPressGestureRecognizer){
        let location = sender.location(in: self)

        if let entity = self.entity(at: location){
            if let anchorEntity = entity.anchor{
                anchorEntity.removeFromParent()
                print("DEBUG: remove anchor with name: \(anchorEntity.name)")
            }
        }
    }
}



