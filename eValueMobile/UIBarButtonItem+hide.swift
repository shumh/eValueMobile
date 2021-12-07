//
//  UIBarButtonItem+hide.swift
//  eValueMobile
//

import UIKit

extension UIBarButtonItem {
    func hide(){
        self.isEnabled = false
        self.tintColor = .clear
    }
}
