//
//  ProfileViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 27.04.2023.
//

import UIKit
import Combine
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logOutOutlet: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var createRegionButton: UIButton!
    
    var viewModel: ProfileViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Профіль"
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid, uid == "mR4zu7K7C0RPTANlifKHjHvLgfk1" {
            createRegionButton.isHidden = false
        }
        
        logOutOutlet.roundCorners(corners: .allCorners, radius: 16)
        logOutOutlet.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        
        userNameLabel.text = Auth.auth().currentUser?.displayName ?? ""
        downloadImage(from: Auth.auth().currentUser!.photoURL!)
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.userImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        viewModel.signOut()
    }
    
    @IBAction func reportHistoryPressed(_ sender: UIButton) {
        viewModel.goToReportsHistory()
    }
    
    @IBAction func createReportPressed(_ sender: UIButton) {
        viewModel.goToCreateReport()
    }
    
    @IBAction func createRegionPressed(_ sender: UIButton) {
        viewModel.goToCreateRegion()
    }
}
