import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class StudentInteractor: StudentInteractorProtocol {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        print("StudentInteractor initialized with Firebase")
    }
    
    func saveUserData(username: String, photo1: UIImage?, photo2: UIImage?) {
        guard !username.isEmpty, let photo1 = photo1, let photo2 = photo2 else {
            print("Incomplete data for saving")
            return
        }
        
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                print("No user after anonymous sign-in")
                return
            }
            
            let uid = user.uid
            let storageRef = self.storage.reference().child("users/\(uid)")
            
            guard let photo1Data = photo1.jpegData(compressionQuality: 0.8),
                  let photo2Data = photo2.jpegData(compressionQuality: 0.8) else {
                print("Error compressing images")
                return
            }
            
            let photo1Ref = storageRef.child("photo1.jpg")
            let photo2Ref = storageRef.child("photo2.jpg")
            
            photo1Ref.putData(photo1Data, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading photo1: \(error.localizedDescription)")
                    return
                }
                photo1Ref.downloadURL { url1, error in
                    if let error = error {
                        print("Error getting photo1 URL: \(error.localizedDescription)")
                        return
                    }
                    
                    photo2Ref.putData(photo2Data, metadata: nil) { _, error in
                        if let error = error {
                            print("Error uploading photo2: \(error.localizedDescription)")
                            return
                        }
                        photo2Ref.downloadURL { url2, error in
                            if let error = error {
                                print("Error getting photo2 URL: \(error.localizedDescription)")
                                return
                            }
                            
                            let userData: [String: Any] = [
                                "username": username,
                                "type": "student",
                                "photo1Url": url1?.absoluteString ?? "",
                                "photo2Url": url2?.absoluteString ?? ""
                            ]
                            
                            self.db.collection("users").document(uid).setData(userData) { error in
                                if let error = error {
                                    print("Error saving user data: \(error.localizedDescription)")
                                } else {
                                    print("Successfully saved UserData for student: \(username)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserData(completion: @escaping (UserData?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            completion(nil)
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error getting user data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = document?.data() else {
                print("No user data found")
                completion(nil)
                return
            }
            
            let username = data["username"] as? String ?? ""
            let type = data["type"] as? String ?? "student"
            let photo1Url = data["photo1Url"] as? String
            let photo2Url = data["photo2Url"] as? String
            
            let userData = UserData(username: username, type: type, photo1Url: photo1Url, photo2Url: photo2Url)
            print("Found student data: \(username)")
            completion(userData)
        }
    }
    
    func loadImage(fromUrl urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }
}
