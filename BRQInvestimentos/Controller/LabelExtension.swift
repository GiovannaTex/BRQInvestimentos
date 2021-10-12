//
//  LabelExtension.swift
//  BRQInvestimentos
//
//  Created by user on 29/09/21.
//

import UIKit

extension UILabel {
    func definirCorVariacao(_ variacao: Double) {
        if variacao > 0 {
            self.textColor = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.0)
        } else if variacao == 0 {
            self.textColor = .white
        } else {
            self.textColor = UIColor(red: 0.815, green: 0.007, blue: 0.105, alpha: 1.0)
        }
    }
}
