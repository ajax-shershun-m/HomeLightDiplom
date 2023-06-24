//
//  LightMissingView.swift
//  HomeLight
//
//  Created by Maksim Shershun on 18.05.2023.
//

import UIKit

class LightMissingView: UIView {

    private lazy var statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var diapazoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(imageName: String, diapazone: String, duration: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 32))
        
        self.addSubview(statusImageView)
        
        NSLayoutConstraint.activate([
            statusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            statusImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        self.addSubview(diapazoneLabel)
        
        NSLayoutConstraint.activate([
            diapazoneLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            diapazoneLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        self.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            durationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            durationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.diapazoneLabel.text = diapazone
        self.durationLabel.text = duration
        self.statusImageView.image = UIImage(named: imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
