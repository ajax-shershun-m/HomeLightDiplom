//
//  SelectRegionViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import Combine

class SelectRegionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: SelectRegionViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Виберіть регіон"
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.shouldReload
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SelectRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        cell.regionLabel.text = viewModel.regions[indexPath.item].name
        
        let radius: CGFloat = 10.0
        
        if indexPath.item == 0 {
            cell.customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.customBackgroundView.layer.cornerRadius = radius
        } else if indexPath.item == viewModel.regions.count - 1 {
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

extension SelectRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.goToFillAddress(with: viewModel.regions[indexPath.item])
    }
}

extension UIView {
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }
}

extension CGRect {
    var topRight: CGPoint { CGPoint(x: maxX, y: minY) }
    var topLeft: CGPoint { CGPoint(x: minX, y: minY) }
    var bottomRight: CGPoint { CGPoint(x: maxX, y: maxY) }
    var bottomLeft: CGPoint { CGPoint(x: minX, y: maxY) }
}
