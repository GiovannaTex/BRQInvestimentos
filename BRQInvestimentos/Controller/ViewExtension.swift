//
//  ViewExtension.swift
//  BRQInvestimentos
//
//  Created by user on 29/09/21.
//

import UIKit

extension UIView {
    func definirBordaView() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = true
    }
}
