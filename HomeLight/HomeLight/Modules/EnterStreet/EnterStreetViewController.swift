//
//  EnterStreetViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 10.05.2023.
//

import UIKit
import Combine

class EnterStreetViewController: UIViewController {

    @IBOutlet weak var streetSearchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EnterStreetViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Виберіть адресу"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        streetSearchTextField.delegate = self
        viewModel
            .shouldReload
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

extension EnterStreetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredStreets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.filteredStreets[indexPath.item].name
        
        cell.customBackgroundView.addBorders(edges: [.left, .right, .bottom], color: UIColor(rgb: 0xEBEBF9))
        
        cell.customBackgroundView.layer.shadowColor = UIColor(rgb: 0x898F96).withAlphaComponent(0.04).cgColor
        cell.customBackgroundView.layer.shadowOpacity = 1
        cell.customBackgroundView.layer.shadowOffset = .zero
        cell.customBackgroundView.layer.shadowRadius = 10
        
        if indexPath.item == 0 {
            cell.customBackgroundView.clipsToBounds = true
            cell.customBackgroundView.layer.cornerRadius = 16
            cell.customBackgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            cell.customBackgroundView.addBorders(edges: [.top, .left, .right], color: UIColor(rgb: 0xEBEBF9))
        } else if indexPath.item == viewModel.filteredStreets.count - 1 {
            cell.customBackgroundView.addBorders(edges: [.bottom, .left, .right], color: UIColor(rgb: 0xEBEBF9))
            
            cell.customBackgroundView.clipsToBounds = true
            cell.customBackgroundView.layer.cornerRadius = 16
            cell.customBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}

extension EnterStreetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToEnterBuilding(with: viewModel.filteredStreets[indexPath.item])
    }
}

extension EnterStreetViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? true) {
            viewModel.filteredStreets = viewModel.streets.filter({ $0.name.uppercased().contains(textField.text!.uppercased()) })
        } else {
            viewModel.filteredStreets = viewModel.streets
        }
        
        tableView.reloadData()
    }
}
