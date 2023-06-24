//
//  CreateReportViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 22.05.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol CreateReportViewModelType {
    var coordinator: CreateReportCoordinator { get }

    func createReport(with image: UIImage, text: String)
}

class CreateReportViewModel: CreateReportViewModelType {
    var ref: DatabaseReference!
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: CreateReportCoordinator
    
    let routing = Routing()
    
    struct Routing: CreateReportRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
    }

    init(coordinator: CreateReportCoordinator) {
        self.coordinator = coordinator
        
        ref = Database.database().reference()
    }
    
    func createReport(with image: UIImage, text: String) {
        if let id = Auth.auth().currentUser?.uid {
            guard let key = ref.child("reports").child(id).childByAutoId().key else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            
            uploadMedia(with: image) { url in
                let place = [
                    "id": UUID().uuidString,
                    "text": text,
                    "date": dateFormatter.string(from: Date()),
                    "image": url
                ]
                let childUpdates = ["/\(id)/\(key)": place]
                self.ref.child("reports").updateChildValues(childUpdates)
                self.routing.close.send()
            }
        }
    }
    
    func uploadMedia(with image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child(UUID().uuidString)
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL { url, error in
                        completion(url?.absoluteString ?? "")
                    }
                    
                }
            }
        }
    }
}

protocol CreateReportRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
}
