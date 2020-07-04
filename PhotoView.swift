//
//  PhotoView.swift
//  WarCardGame
//
//  Created by Mitchell Park on 5/30/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoView: UIViewController {
    
    let exitButton = UIButton()
    let saveButton = UIButton()
    var data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(data: Data){
        super.init()
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPhoto(photo: AVCapturePhoto){
        if let data = photo.fileDataRepresentation(){
            if let image = UIImage(data: data){
                displayImage(image: image)
            }
        }else{
            print("could not show photo")
        }
    }
    
    private func displayImage(image: UIImage){
        let imgView = UIImageView(image: image)
        view.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imgView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        setExitButton(imgView: imgView)
        setSaveButton()
    }
    
    private func setExitButton(imgView: UIImageView){
        imgView.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -20),
            exitButton.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 20)
        ])
        exitButton.backgroundColor = .red
        exitButton.layer.cornerRadius = 25
        exitButton.addTarget(self, action: #selector(unpresent), for: .touchUpInside)
    }
    
    private func setSaveButton(){
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        saveButton.backgroundColor = .blue
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
    }
    
    @objc
    public func savePhoto(){
        let vc = SavePhotoVC(data: self.data)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc
    func unpresent(){
        
    }
    
    
}
