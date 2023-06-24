//
//  PlacesListViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class PlacesListViewController: UIViewController {

    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFirstLocationButtonOutlet: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: PlacesListViewModelType!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emptyListView.isHidden = !viewModel.places.isEmpty
        
        addFirstLocationButtonOutlet.layer.borderWidth = 1
        addFirstLocationButtonOutlet.layer.borderColor = UIColor(rgb: 0xEBEBF9).cgColor
        
        addFirstLocationButtonOutlet.layer.shadowColor = UIColor(rgb: 0x898F96).withAlphaComponent(0.04).cgColor
        addFirstLocationButtonOutlet.layer.shadowOpacity = 1
        addFirstLocationButtonOutlet.layer.shadowOffset = .zero
        addFirstLocationButtonOutlet.layer.shadowRadius = 10
        
        viewModel
            .shouldReload
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                emptyListView.isHidden = !viewModel.places.isEmpty
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let image = Auth.auth().currentUser != nil ? UIImage(systemName: "person.crop.circle") : UIImage(systemName: "person.crop.circle.badge.plus")
        
        viewModel.reloadPlaces()
        
        self.navigationItem.rightBarButtonItem = .init(
            image: image,
            style: .plain,
            target: self,
            action: #selector(self.openAccount)
        )
        
        title = "Home Light"
    }
    
    @objc func openAccount() {
        if Auth.auth().currentUser != nil {
            viewModel.goToProfile()
            return
        }
        signUp()
    }
    
    @IBAction func addFirstButtonPressed(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            viewModel.goToSelectRegion()
        } else {
            let alert = UIAlertController(title: "Увага", message: "Для створення локації вам потрібно авторизуватися", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Гаразд", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            viewModel.goToSelectRegion()
        } else {
            viewModel.goToSelectRegion()
            let alert = UIAlertController(title: "Увага", message: "Для створення локації вам потрібно авторизуватися", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Гаразд", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

private extension PlacesListViewController {
    func signUp() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else { return }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                guard let self = self else { return }
                
                let image = Auth.auth().currentUser != nil ? UIImage(systemName: "person.crop.circle") : UIImage(systemName: "person.crop.circle.badge.plus")
                
                self.navigationItem.rightBarButtonItem = .init(
                    image: image,
                    style: .plain,
                    target: self,
                    action: #selector(self.openAccount)
                )
            }
        }
    }
}

extension PlacesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.placeTitleLabel.text = viewModel.places[indexPath.item].name
        cell.placeCityLabel.text = viewModel.places[indexPath.item].city
        cell.placeGroupLabel.text = viewModel.places[indexPath.item].group
        cell.cardView.layer.borderWidth = 1
        cell.cardView.layer.borderColor = UIColor(rgb: 0xEBEBF9).cgColor
        
        cell.cardView.layer.shadowColor = UIColor(rgb: 0x898F96).withAlphaComponent(0.04).cgColor
        cell.cardView.layer.shadowOpacity = 1
        cell.cardView.layer.shadowOffset = .zero
        cell.cardView.layer.shadowRadius = 10
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension PlacesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.goToPlaceDetails(viewModel.places[indexPath.item])
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
