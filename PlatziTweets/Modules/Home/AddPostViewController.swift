//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-09-05.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage
import AVFoundation
import AVKit
import MobileCoreServices

class AddPostViewController: UIViewController {
    // MARK: - Properties
    private var imagePicker: UIImagePickerController?
    private var currentVideoURL: URL?
    private var isVideo: Bool  = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func addPostAction(){
        uploadMediaToFirebase(isVideo: isVideo)
    }
    
    @IBAction func openPreviewAction() {
        guard let recordedVideoUrl = currentVideoURL else {
            return
        }
        let avPlayer = AVPlayer(url: recordedVideoUrl)
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true){
            avPlayerController.player?.play()
        }
    }
    
    @IBAction func dismissAction(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func openCameraAction() {
        let alert = UIAlertController(title: "Cámara", message: "Selecciona una opción", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.isVideo = false
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.isVideo = true
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .auto
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        if self.isVideo {
            imagePicker?.mediaTypes = [kUTTypeMovie as String]
            imagePicker?.cameraCaptureMode = .video
            imagePicker?.videoQuality = .typeMedium
            imagePicker?.videoMaximumDuration = TimeInterval(5)
        }
        
        guard let imagePicker = imagePicker else {
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadMediaToFirebase(isVideo: Bool){
        // 1. Asegurarnos que el archivo exista
        // 2. Comprimir imagen y convertirla en Data
        var fileData: Data = Data()
        
        if let currentVideoSavedURL = currentVideoURL,
            let videoData: Data = try? Data(contentsOf: currentVideoSavedURL)
        {
            fileData = videoData
            
        }else if let imageSaved = previewImageView.image,
            let imageSavedData: Data = imageSaved.jpegData(compressionQuality: 0.1)
        {
            fileData = imageSavedData
        }
        
        SVProgressHUD.show()
        
        // 3. Configuracion para guardar foto en firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = isVideo ? "image/jpg" : "video/MP4"
        
        // 4. Referencia al storage de firebase
        let storage = Storage.storage()
        
        // 5. Crear nombre de imagen a subir
        let fileName = Int.random(in: 100...1000)
        
        let folderName = isVideo ? "videos-tweets" : "fotos-tweets"
        
        let fileExtension = isVideo ? "mp4" : "jpg"
        
        // 6. Referencia a carpeta donde se va a guardar la foto
        let folderReference = storage.reference(withPath: "\(folderName)/\(fileName).\(fileExtension)")
        
        // 7. Subir la foto a Firebase
        DispatchQueue.global(qos: .background).async {
            folderReference.putData(fileData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error: Error?) in
                
                DispatchQueue.main.async {
                    //Detener la carga
                    SVProgressHUD.dismiss()
                    
                    if let error = error {
                        NotificationBanner(title: "Error", subtitle: error.localizedDescription,style: .warning).show()
                        return
                    }
                    
                    // Obtener la URL de descarga
                    folderReference.downloadURL { (url: URL?, error: Error?) in
                        let downloadUrl = url?.absoluteString ?? ""
                        if self.isVideo{
                            self.savePost(imageUrl: nil, videoUrl: downloadUrl)
                        }else{
                            self.savePost(imageUrl: downloadUrl, videoUrl: nil)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    private func savePost(imageUrl: String?, videoUrl: String?){
                
        // 1. Crear request
        let request = PostRequest(text: postTextView.text, imageUrl: imageUrl, videoUrl: videoUrl, location: nil)
        
        // 2. Indicar carga al usuario
        SVProgressHUD.show()
        
        // 3. Llamar al servicio del post
        SN.post(endpoint: Endpoints.posts, model: request) { (result: SNResultWithEntity<PostItem, ErrorResponse>) in
                        
            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
                
            case .error(let error):
                NotificationBanner(title: "Error",
                                   subtitle: error.localizedDescription, style: .danger).show()
            case .errorResult(let entity):
                NotificationBanner(title: "Error",
                                   subtitle: entity.error,
                                   style: .warning).show()
            }
            // 4. Cerramos el indicador de carga
            SVProgressHUD.dismiss()
        }
        
    }
}

// MARk: - UIImageViewControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        // Cerrar camara
        imagePicker?.dismiss(animated: true, completion: nil)
        
        // Capturar imagen
        if info.keys.contains(.originalImage){
            previewImageView.isHidden = false
            //Obtenemos la imagen tomada
            previewImageView.image = info[.originalImage] as? UIImage
        }
        
        // Obtener url video
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
        
        
    }
}
