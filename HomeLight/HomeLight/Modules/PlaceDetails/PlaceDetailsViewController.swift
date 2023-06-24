//
//  PlaceDetailsViewController.swift
//  HomeLight
//
//  Created by Maksim Shershun on 06.05.2023.
//

import UIKit
import Combine

class PlaceDetailsViewController: UIViewController {

    @IBOutlet weak var graphicsContainerView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeRegionLabel: UILabel!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet var weekDayButtonOutlet: [UIButton]!
    @IBOutlet weak var lightMissingStackView: UIStackView!
    
    private var dayIndex = (Date().dayNumberOfWeek() ?? 0) - 1
    
    var viewModel: PlaceDetailsViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.currentSelectedDayIndex = dayIndex
        
        weekDayButtonOutlet.forEach { button in
            button.layer.cornerRadius = button.frame.width / 2
        }
        
        graphicsContainerView.layer.borderWidth = 1
        graphicsContainerView.layer.borderColor = UIColor(rgb: 0xEBEBF9).cgColor
        
        graphicsContainerView.layer.shadowColor = UIColor(rgb: 0x898F96).withAlphaComponent(0.04).cgColor
        graphicsContainerView.layer.shadowOpacity = 1
        graphicsContainerView.layer.shadowOffset = .zero
        graphicsContainerView.layer.shadowRadius = 10
        
        placeNameLabel.text = viewModel.placeModel.name
        placeRegionLabel.text = viewModel.placeModel.city
        placeLocationLabel.text = viewModel.placeModel.group
        
        weekDayButtonOutlet.first(where: { $0.tag == dayIndex })?.alpha = 0.5

        drawGraphics()
    }
    
    @IBAction func weekDayButtonPressed(_ sender: UIButton) {
        viewModel.currentSelectedDayIndex = sender.tag
        
        weekDayButtonOutlet.forEach { button in
            button.alpha = button.tag == sender.tag ? 0.5 : 1
        }
        
        drawGraphics()
    }
    
    func drawGraphics() {
        lightMissingStackView.arrangedSubviews.compactMap({ $0.removeFromSuperview() })
        
        viewModel.data[Int(viewModel.placeModel.group) ?? -1][viewModel.currentSelectedDayIndex].enumerated().forEach { (index, missingLightModel) in
            if index == 0 && missingLightModel.start != 0 {
                let startZero = missingLightModel.start < 10 ? "0" : ""
                
                let view = LightMissingView(
                    imageName: missingLightModel.type == .definiteOutage ? "flash-off" : "warning",
                    diapazone: "00:00 - \(startZero)\(missingLightModel.start):00",
                    duration: "\(missingLightModel.start)г"
                )
                
                lightMissingStackView.addArrangedSubview(view)
            }
            
            let startZero = missingLightModel.start < 10 ? "0" : ""
            let endZero = missingLightModel.end < 10 ? "0" : ""
            
            let view = LightMissingView(
                imageName: missingLightModel.type == .definiteOutage ? "flash-off" : "warning",
                diapazone: "\(startZero)\(missingLightModel.start):00 - \(endZero)\(missingLightModel.end):00",
                duration: "\(missingLightModel.end - missingLightModel.start)г"
            )
            
            lightMissingStackView.addArrangedSubview(view)
        }
    }
    
    @IBAction func deleteLocation(_ sender: UIButton) {
        viewModel.deletePlace()
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
