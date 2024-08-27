//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var conditiionLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var detail: Detail?
    var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        loadSubviews()
    }
    
    func loadSubviews() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        
        guard let detail = detail else { return }
        cityNameLabel.text = detail.name
        currentTempLabel.text = detail.main.temp.kelvinToFahrenheit()
        conditiionLabel.text = detail.primaryWeather?.main
        maxMinTempLabel.text = "H: \(detail.main.temp_max.kelvinToFahrenheit())  L: \(detail.main.temp_min.kelvinToFahrenheit())"
        timeLabel.text = detail.date
        downloadIcon(id: detail.primaryWeather?.icon ?? "")
    }
    
    @objc func search() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func downloadIcon(id: String) {
        viewModel?.loadImage(id: id, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.iconImageView.image = image
            }
        })
    }
}

