//
//  UIViewController + Ext.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String?,
        message: String?,
        image: UIImage? = UIImage(systemName: "info"),
        buttonTitle: String?,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: style, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
}
