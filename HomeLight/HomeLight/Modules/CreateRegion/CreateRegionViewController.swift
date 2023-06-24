//
//  CreateRegionViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 20.06.2023.
//

import UIKit
import Combine

class CreateRegionViewController: UIViewController {
    
    var viewModel: CreateRegionViewModelType!
    @IBOutlet weak var groupsCountLabel: UILabel!
    @IBOutlet weak var groupsStepper: UIStepper!
    @IBOutlet weak var addressSupportTogle: UISwitch!
    @IBOutlet weak var regionNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsStepper.value = 6
        groupsStepper.maximumValue = 8
        groupsStepper.minimumValue = 1
        groupsStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = "Створення регіону"
    }
    
    @IBAction func addRegionPressed(_ sender: UIButton) {
        if regionNameTextField.text?.isEmpty ?? false {
            let alert = UIAlertController(title: "Увага", message: "Назва регіону не може бути пустою, додайте назву для того щоб регіон створився", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Гаразд", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            viewModel.createRegion(regionNameTextField.text ?? "", Int(groupsStepper.value), addressSupportTogle.isOn)
        }
    }
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        groupsCountLabel.text = "Кількість груп: \(Int(stepper.value))"
    }
}
