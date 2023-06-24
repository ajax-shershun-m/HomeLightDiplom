//
//  FillAddressViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class FillAddressViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: FillAddressViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel.placeModel.city
        navigationController?.navigationBar.topItem?.title = " "
    }
}

extension FillAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataToFill.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.dataToFill[indexPath.item].title
        
        let radius: CGFloat = 10.0
        
        if indexPath.item == 0 {
            cell.customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.customBackgroundView.layer.cornerRadius = radius
        } else if indexPath.item == viewModel.dataToFill.count - 1 {
            cell.customBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.customBackgroundView.layer.cornerRadius = radius
        }
        cell.customBackgroundView.layer.borderWidth = 1
        cell.customBackgroundView.layer.borderColor = UIColor(rgb: 0xEBEBF9).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}

extension FillAddressViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.dataToFill[indexPath.item] {
        case .address:
            viewModel.goToSelectAddress()
        case .group:
            viewModel.goToSelectGroup()
        }
    }
}
