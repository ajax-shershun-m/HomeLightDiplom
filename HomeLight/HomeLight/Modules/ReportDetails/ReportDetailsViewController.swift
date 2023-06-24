//
//  ReportDetailsViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 17.06.2023.
//

import UIKit
import Combine

class ReportDetailsViewController: UIViewController {
    
    @IBOutlet weak var reportDetailsImageView: UIImageView!
    @IBOutlet weak var reportDetailsTextView: UITextView!
    
    var viewModel: ReportDetailsViewModelType!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportDetailsTextView.text = viewModel.report.text
        downloadImage(from: viewModel.report.image)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.reportDetailsImageView.image = UIImage(data: data)
                self?.reportDetailsImageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.title = "Деталі заявки"
    }
}
