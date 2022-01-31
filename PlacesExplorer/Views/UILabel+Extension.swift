//
//  UILabel+Extension.swift
//  PlacesExplorer
//
//  Created by Andrii Shkliaruk on 30.01.2022.
//

import UIKit

extension UILabel {
    func setupOrHide(prefix: String?, suffix: String?) {
        if let text = suffix, suffix != "" {
            if let title = prefix {
                self.text = "\(title) \(text)"
            } else {
                self.text = text
            }
        } else {
            self.isHidden = true
        }
    }
}
