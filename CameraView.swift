//
//  CameraView.swift
//  WarCardGame
//
//  Created by Mitchell Park on 5/28/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraView: UIViewController {
    
    //Views
    let warningView = UIView()
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        setPreview()
        requestCameraAuth()
        addButton()
    }
    
    //MARK: -Authorization
    private func requestCameraAuth(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.setupCaptureSession()
            
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            
        case .denied, .restricted:
                popUpWarning()
        default:
            fatalError("Unknown Auth failutre")
        }
    }
    
    private func popUpWarning(){
        let title = UILabel()
        let caption = UILabel()
        let button = UIButton()
        
        view.addSubview(warningView)
        warningView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warningView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            warningView.heightAnchor.constraint(equalToConstant: 200),
            warningView.widthAnchor.constraint(equalToConstant: 300)
        ])
        warningView.backgroundColor = .white
        warningView.layer.cornerRadius = 15
        warningView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        warningView.addSubview(title)
        title.text = "Oops!"
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: warningView.centerXAnchor),
            title.heightAnchor.constraint(equalToConstant: 40),
            title.widthAnchor.constraint(equalTo: warningView.widthAnchor),
            title.topAnchor.constraint(equalTo: warningView.topAnchor)
        ])
        
        warningView.addSubview(caption)
        caption.numberOfLines = 0
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.textAlignment = .center
        caption.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        caption.text = "Snapchat is a camera app. Please change ur settings,"
        NSLayoutConstraint.activate([
            caption.topAnchor.constraint(equalTo: title.bottomAnchor),
            caption.centerXAnchor.constraint(equalTo: warningView.centerXAnchor),
            caption.widthAnchor.constraint(equalTo: warningView.widthAnchor),
            caption.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        warningView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(lessThanOrEqualTo: warningView.bottomAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Go to Settings", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        
    }
    
    @objc
    func goToSettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString) else{
            return
        }
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    private func getValidDevice()->AVCaptureDevice{
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = discoverySession.devices
        guard let bestDevice = devices.first else{
            fatalError("No valid devices")
        }
        return bestDevice
    }
    
    //MARK: -SESSION steup
    private func setupCaptureSession(){
        captureSession.beginConfiguration()
        
        //Input setup
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: getValidDevice()), captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        //Output setup
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .hd4K3840x2160
        
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    func setPreview(){
        let preview = previewView()
        preview.videoPreviewLayer.session = captureSession
        view = preview
    }
    private func addButton(){
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
    }
    
    @objc
    func takePhoto(){
        let settings = AVCapturePhotoSettings(format:  [AVVideoCodecKey: AVVideoCodecType.jpeg])
        settings.isHighResolutionPhotoEnabled = false
        settings.flashMode = .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}
extension CameraView: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }else{
            let vc = PhotoView(data: photo.fileDataRepresentation()!)
            vc.setPhoto(photo: photo)
            present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
}
class previewView: UIView{
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer{
        return layer as! AVCaptureVideoPreviewLayer
    }
}

