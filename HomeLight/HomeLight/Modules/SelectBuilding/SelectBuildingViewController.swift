//
//  SelectBuildingViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 18.06.2023.
//

import UIKit
import Combine

class SelectBuildingViewController: UIViewController {

    @IBOutlet weak var streetSearchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SelectBuildingViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Виберіть номер будинку"
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

extension SelectBuildingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredBuildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.filteredBuildings[indexPath.item].name
        
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
        } else if indexPath.item == viewModel.filteredBuildings.count - 1 {
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

extension SelectBuildingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToCreatePlace(with: viewModel.filteredBuildings[indexPath.item])
    }
}

extension SelectBuildingViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? true) {
            viewModel.loadJson(fromURLString: "https://yasno.com.ua/api/v1/electricity-outages-schedule/house?region=kiev&street_id=\(viewModel.street.id)&query=\(textField.text!)") { [weak self] result in
                switch result {
                case .success(let data):
                    print(data)
                    self?.viewModel.filteredBuildings = data
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            viewModel.filteredBuildings = []
        }
        
        tableView.reloadData()
    }
}
