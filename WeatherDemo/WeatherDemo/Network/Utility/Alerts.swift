//
//  Alert.swift
//  WeatherDemo
//
//  Created by Peide Xiao on 8/27/24.
//

import Foundation
import UIKit

class Alerts {
    
    static func show(_ viewController: UIViewController, _ message: String) {
        showActionAlert(viewController: viewController, title: nil, message: message, actions: [("OK", UIAlertAction.Style.cancel)]) { _ in }
    }
    
    static func showActionAlert(viewController: UIViewController, title: String?, message: String?, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        viewController.present(alertViewController, animated: true, completion: nil)
    }
}

