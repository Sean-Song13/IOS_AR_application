//
//  GalleryViewController.swift
//  AR-Demo
//
//  Created by xinhao.song on 2021/11/15.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var modelNames:[String] = ["gramophone", "toy_biplane","tv_retro", "teapot"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(GifCollectionViewCell.nib(), forCellWithReuseIdentifier: GifCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        // Do any additional setup after loading the view.
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

enum ImageType : CaseIterable{
    case standard
    case gif
    case threeD
    
    var section: Int{
        get{
            switch self {
            case .standard:
                return 0
            case .gif:
                return 1
            case .threeD:
                return 2
            }
        }
    }
    
    var label: String{
        get{
            switch self {
            case .standard:
                return "Static Image"
            case .gif:
                return "Gif Image"
            case .threeD:
                return "3D Model"
            }
        }
    }
}

struct modelSelectedNotificationObject {
    var modelName: String
    var type: ImageType
    
    init(modelName:String, type:ImageType) {
        self.modelName = modelName
        self.type = type
    }
}

extension GalleryViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case ImageType.standard.section:
            return modelNames.count
        case ImageType.gif.section:
            return 4
        case ImageType.threeD.section:
            return modelNames.count
        default:
            print("No section with \(section)")
            return -1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ImageType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == ImageType.standard.section {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: UIImage(named: modelNames[indexPath.row])!)
            return cell
        }
        if indexPath.section == ImageType.gif.section {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionViewCell.identifier, for: indexPath) as! GifCollectionViewCell
            cell.configure(with: "RickandMorty-" + String(indexPath.row))
            return cell
        }
        if indexPath.section == ImageType.threeD.section {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: UIImage(named: modelNames[indexPath.row])!)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
          // 1
          case UICollectionView.elementKindSectionHeader:
            // 2
            let headerView = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: "\(SectionHeaderView.self)",
              for: indexPath)

            // 3
            guard let typedHeaderView = headerView as? SectionHeaderView
            else { return headerView }

            // 4
            switch indexPath.section {
                case ImageType.standard.section:
                    typedHeaderView.titleLabel.text = ImageType.standard.label
                case ImageType.gif.section:
                    typedHeaderView.titleLabel.text = ImageType.gif.label
                case ImageType.threeD.section:
                    typedHeaderView.titleLabel.text = ImageType.threeD.label
            
                default:
                    assert(false, "Invalid element type")
            }
            return typedHeaderView
          default:
            // 5
            assert(false, "Invalid element type")
          }

    }
    
}

extension GalleryViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == ImageType.standard.section{
            let modelName = modelNames[indexPath.row]
            let object = modelSelectedNotificationObject(modelName: modelName, type: .standard)
            NotificationCenter.default.post(name: Notification.Name("modelSelected"), object: object)
            dismiss(animated: true, completion: nil)
        }
        
        if indexPath.section == ImageType.gif.section{
            let gifNamed = "RickandMorty-" + String(indexPath.row)
            let object = modelSelectedNotificationObject(modelName: gifNamed, type: .gif)
            NotificationCenter.default.post(name: Notification.Name("modelSelected"), object: object)
            dismiss(animated: true, completion: nil)
        }
        
        if indexPath.section == ImageType.threeD.section{
            let modelName = modelNames[indexPath.row]
            let object = modelSelectedNotificationObject(modelName: modelName, type: .threeD)
            NotificationCenter.default.post(name: Notification.Name("modelSelected"), object: object)
            dismiss(animated: true, completion: nil)
        }
        
//        print("tapped")
    }
    
}

extension GalleryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == ImageType.standard.section ||
            indexPath.section == ImageType.threeD.section {
            return CGSize(width: view.frame.size.width/3-3, height: view.frame.size.width/3-3)
        }
        return CGSize(width: view.frame.size.width/2-2, height: view.frame.size.width/3-3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 30)
    }
}
