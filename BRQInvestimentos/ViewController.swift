//
//  ViewController.swift
//  BRQInvestimentos
//
//  Created by user on 09/09/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var moedas = ["USD", "EUR", "ARS", "USD", "EUR", "ARS"]
    var cotacoes = ["0,53%", "0%", "-1,12%", "0,53%", "0%", "-1,12%"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        title = "Moedas"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moedas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moedaCell", for: indexPath) as! MoedaTableViewCell
        
        cell.moedaLabelView.text = moedas[indexPath.row]
        cell.cotacaoLabelView.text = cotacoes[indexPath.row]
        
        
        cell.moedaView.layer.cornerRadius = 15
        cell.moedaView.layer.borderWidth = 1
        cell.moedaView.layer.borderColor = UIColor.white.cgColor
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

