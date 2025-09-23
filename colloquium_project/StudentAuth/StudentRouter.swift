import UIKit
import AVFoundation
import Photos

class StudentRouter: StudentRouterProtocol {
    weak var viewController: StudentViewController?
    
    init(viewController: StudentViewController) {
        self.viewController = viewController
    }
    
    func presentImageOptions(for source: ImageSource, isGalleryAllowed: Bool) {
        guard let viewController = viewController else { return }
        
        let actionSheet = UIAlertController(title: "Выберите источник", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.presentCamera(for: source)
        }))
        
        if isGalleryAllowed {
            actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
                self.presentGallery(for: source)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        viewController.present(actionSheet, animated: true)
    }
    
    private func presentCamera(for source: ImageSource) {
        guard let viewController = viewController else { return }
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = viewController
            viewController.currentImageSource = source
            viewController.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentCamera(for: source)
                    }
                }
            }
        default:
            viewController.present(UIAlertController(title: "Ошибка", message: "Доступ к камере запрещён", preferredStyle: .alert), animated: true)
        }
    }
    
    private func presentGallery(for source: ImageSource) {
        guard let viewController = viewController else { return }
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .authorized, .limited:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = viewController
            viewController.currentImageSource = source
            viewController.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    DispatchQueue.main.async {
                        self.presentGallery(for: source)
                    }
                }
            }
        default:
            viewController.present(UIAlertController(title: "Ошибка", message: "Доступ к галерее запрещён", preferredStyle: .alert), animated: true)
        }
    }
}
