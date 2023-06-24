//
//  ReportsHistoryViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 15.06.2023.
//

import UIKit
import Combine

class ReportsHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ReportsHistoryViewModelType!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .shouldReload
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = "Історія заявок"
    }
    
}

extension ReportsHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.reports[indexPath.item].date
        
        cell.customBackgroundView.layer.shadowColor = UIColor(rgb: 0x898F96).withAlphaComponent(0.04).cgColor
        cell.customBackgroundView.layer.shadowOpacity = 1
        cell.customBackgroundView.layer.shadowOffset = .zero
        cell.customBackgroundView.layer.shadowRadius = 10
        
        cell.customBackgroundView.layer.cornerRadius = 16
        
        cell.customBackgroundView.layer.borderWidth = 1
        cell.customBackgroundView.layer.borderColor = UIColor(rgb: 0xEBEBF9).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reports.count
    }
}

extension ReportsHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToReportDetails(id: viewModel.reports[indexPath.item])//бо йобані хедери
    }
}
