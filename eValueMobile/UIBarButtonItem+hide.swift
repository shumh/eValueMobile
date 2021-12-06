//
//  UIBarButtonItem+hide.swift
//  eValueMobile
//
//  Created by Richard Shum on 12/6/21.
//

import UIKit

extension UIBarButtonItem {
    func hide(){
        self.isEnabled = false
        self.tintColor = .clear
    }
}
