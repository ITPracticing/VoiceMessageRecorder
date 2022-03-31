//
//  Extensions.swift
//  VoiceRecorderDemo
//
//  Created by F_Sur on 31/03/2022.
//

import UIKit

// MARK: - Alert

extension UIViewController {

    func presentAlert(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertVC.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}
