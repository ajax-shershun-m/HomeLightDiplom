//
//  CreatePlaceViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class CreatePlaceViewController: UIViewController {
    
    var viewModel: CreatePlaceViewModelType!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel.placeModel.city
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if placeNameTextField.text?.isEmpty ?? false {
            let alert = UIAlertController(title: "Увага", message: "Назва локації не може бути пустою, додайте назву для того щоб локація створилася", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Гаразд", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            viewModel.save(placeNameTextField.text ?? "")
        }
    }
}
