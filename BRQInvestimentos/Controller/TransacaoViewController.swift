//
//  TransacaoViewController.swift
//  BRQInvestimentos
//
//  Created by user on 20/09/21.
//

import UIKit

class TransacaoViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var textoLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    // MARK: Propriedades
    var texto = String()

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        textoLabel.text = texto
        
        homeButton.layer.cornerRadius = 20
        homeButton.layer.masksToBounds = true
        homeButton.isEnabled = true
    }

    // MARK: Actions
    @IBAction func homeTapped(_ sender: UIButton) {
        if let nc = navigationController {
            nc.popToRootViewController(animated: true)
        }
    }
}
