//
//  SavePhotoVC.swift
//  WarCardGame
//
//  Created by Mitchell Park on 6/3/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class SavePhotoVC: UIViewController {
    
    let saveButton = UIButton()
    var data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSaveButton()
    }
    
    init(data: Data){
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSaveButton(){
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        saveButton.setTitle("Save Photo", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.addTarget(self, action: #selector(requestSaveAuth), for: .touchUpInside)
    }
    
    @objc
    func requestSaveAuth(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            savePhoto()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.savePhoto()
                }else{
                    self.popUpWarning()
                }
            }
        default:
            popUpWarning()
        }
    }
    
    func savePhoto(){
        PHPhotoLibrary.shared().performChanges({
            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: self.data, options: .none)
        }, completionHandler: nil)
    }
    
    func popUpWarning(){
        
    }
}
