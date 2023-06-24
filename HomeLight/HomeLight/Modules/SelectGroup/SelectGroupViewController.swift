//
//  SelectGroupViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class SelectGroupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SelectGroupViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel.placeModel.city
        navigationController?.navigationBar.topItem?.title = " "
    }
}

extension SelectGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataToFill.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.dataToFill[indexPath.item]
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 24, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Виберіть ваш номер групи:"
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        label.textColor = UIColor(rgb: 0x1A1E2C)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension SelectGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToCreatePlace(with: viewModel.dataToFill[indexPath.item])
    }
}
