//
//  GifAnimationHelper.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/12/3.
//

import Foundation
import UIKit
import RealityKit

class GifAnimationHelper {
    private var firstFrame:UIImage?
    private var ratio:Float?
    
    func playGifAnimation(gifNamed:String, modelEntity:ModelEntity){
        if let materials = getMaterialList(gifNamed: gifNamed){
            repeatAnimateImagesChanges(materials: materials, modelEntity: modelEntity, index: 0)
        }
    }
    
    private func getMaterialList(gifNamed:String) -> [SimpleMaterial]?{
        var materials = [SimpleMaterial]()
        if let urls = getPngSequenceURL(gifNamed: gifNamed){
            for url in urls {
                var material = SimpleMaterial()
                material.tintColor = UIColor(white: 1.0, alpha: 0.9999)
                material.baseColor = try! MaterialColorParameter.texture(TextureResource.load(contentsOf: url))
                material.roughness = MaterialScalarParameter(floatLiteral: 0.5)
                material.metallic = MaterialScalarParameter(floatLiteral: 0.5)
                materials.append(material)
            }
        }
        return materials
    }
    
    private func repeatAnimateImagesChanges(materials:[SimpleMaterial], modelEntity:ModelEntity, index:Int) {

        if(materials.count == 0) {
            return
        }

        var newMaterial = [materials.first!]
        let current = index > materials.count - 1 ? 0 : index

        if(modelEntity.model?.materials != nil && modelEntity.model?.materials.count ?? 0 > 0) {
//            for i in 0..<materials.count {
//                newMaterial = [materials[i]]
//                let currentMaterial = modelEntity.model?.materials[0] as! SimpleMaterial
//                if(currentMaterial.isEqual(anotherMaterial: newMaterial[0])) {
//                    newMaterial = [i == materials.count - 1 ? materials.first! : materials[i]]
//                }
//            }
            newMaterial = [materials[current]]
        }

        modelEntity.model?.materials = newMaterial

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.repeatAnimateImagesChanges(materials: materials, modelEntity: modelEntity, index: current + 1)
        }
    }
    
    private func getPngSequenceURL(gifNamed: String) -> [URL]?{
        let documentURL = getDocumentsDirectory().appendingPathComponent(gifNamed)
        let directoryContents = try? FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
        let urlList = directoryContents?.filter{ $0.pathExtension == "png" }
        return urlList?.sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
    }
    
    func getAtio() -> Float? {
        return ratio
    }
    
    func saveGifAsPngSequence(gifNamed: String) {

        guard let bundleURL = Bundle.main
            .url(forResource: gifNamed, withExtension: "gif") else {
                print("This image named \"\(gifNamed)\" does not exist!")
                return
        }

        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("Cannot turn image named \"\(gifNamed)\" into NSData")
            return
        }

        let gifOptions = [
            kCGImageSourceShouldAllowFloat as String : true as NSNumber,
            kCGImageSourceCreateThumbnailWithTransform as String : true as NSNumber,
            kCGImageSourceCreateThumbnailFromImageAlways as String : true as NSNumber
            ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, gifOptions) else {
            debugPrint("Cannot create image source with data!")
            return
        }

        let framesCount = CGImageSourceGetCount(imageSource)
        var frameList = [UIImage]()

        for index in 0 ..< framesCount {

            if let cgImageRef = CGImageSourceCreateImageAtIndex(imageSource, index, nil) {
                let uiImageRef = UIImage(cgImage: cgImageRef)
                frameList.append(uiImageRef)
            }

        }
        
        firstFrame = frameList[0]
        if let frame = firstFrame {
            ratio = Float(frame.size.height ) / Float(frame.size.width)
        }
        
        let directoryName = getDocumentsDirectory().appendingPathComponent(gifNamed)
        if !FileManager.default.fileExists(atPath: directoryName.path) {
            do {
                try FileManager.default.createDirectory(atPath: directoryName.path, withIntermediateDirectories: true, attributes: nil)
                }
            catch {
                NSLog("Couldn't create document directory")
            }
        }
        if FileManager.default.fileExists(atPath: directoryName.path) {
            for index in 0 ..< framesCount {
                let image = frameList[index]
                if let data = image.pngData() {
                    let suffix = gifNamed + "_" + String(index) + ".png"
                    let filename = directoryName.appendingPathComponent(suffix)
                    try? data.write(to: filename, options: [.withoutOverwriting])
                }
            }
        }

//        return frameList
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let paths = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        return paths[0]
    }
}

//extension SimpleMaterial{
//    func isEqual(anotherMaterial: SimpleMaterial) -> Bool {
//        return self.baseColor == anotherMaterial.baseColor
//    }
//}
