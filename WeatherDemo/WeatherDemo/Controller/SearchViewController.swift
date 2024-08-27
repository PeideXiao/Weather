//
//  SearchViewController.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/26/24.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detail = viewModel.detail {
            self.navigateToDetailViewController(with: detail)
            return
        }
        loadFirstTimeLocation()
    }
    
    private func loadFirstTimeLocation() {
        viewModel.isLocationServiceOn = true
        viewModel.locationCompletion = { [unowned self] error in
            if let error = error {
                DispatchQueue.main.async {[unowned self] in
                    Alerts.show(self, error)
                    return
                }
            }
            
            if let detail = self.viewModel.detail {
                DispatchQueue.main.async {[weak self] in
                    self?.navigateToDetailViewController(with: detail)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.resignFirstResponder()
    }
    
    private func navigateToDetailViewController(with detail: Detail) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? WeatherViewController {
            detailVC.detail = detail
            self.navigationController?.pushViewController(detailVC, animated: false)
        }
    }
    
    @IBAction func search(_ sender: Any) {
        _ = [self.cityTF, self.stateTF, self.countryTF].map({ $0?.resignFirstResponder() })
        guard cityTF.hasText else {
            Alerts.show(self, "Please enter city name.")
            return
        }
        
        // It seems the api success when there is city and country, but fails only there city and state
        if stateTF.hasText && !countryTF.hasText {
            Alerts.show(self, "Please enter country name.")
            return
        }
        
        // only validate city name from memory
        if let detail = UserDefaults.standard.read(for: last_city_searched_key), detail.name.lowercased() == cityTF.text!.lowercased() {
            self.navigateToDetailViewController(with: detail)
            return
        }
        
        viewModel.fetchWeatherDetail(city: cityTF.text!, state: stateTF.text, country: countryTF.text) { [unowned self] error in
            DispatchQueue.main.async {
                if let error = error {
                    Alerts.show(self, error)
                    return
                }
                
                guard let detail = self.viewModel.detail else { return }
                self.navigateToDetailViewController(with: detail)
            }
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

