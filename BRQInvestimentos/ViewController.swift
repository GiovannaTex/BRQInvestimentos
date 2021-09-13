//
//  ViewController.swift
//  BRQInvestimentos
//
//  Created by user on 09/09/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    // MARK: Properties
    var currencies = ["USD", "EUR", "GBP", "ARS", "CAD", "AUD", "JPY", "CNY", "BTC"]
    var variations = [Double]()
    
    let urlString = "https://api.hgbrasil.com/finance?key=ddc1480f"
        
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        title = "Moedas"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
    }
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()

        if let parsedJSON = try? decoder.decode(Entry.self, from: json) {
            variations.append(parsedJSON.results.currencies.USD.variation)
            variations.append(parsedJSON.results.currencies.EUR.variation)
            variations.append(parsedJSON.results.currencies.GBP.variation)
            variations.append(parsedJSON.results.currencies.ARS.variation)
            variations.append(parsedJSON.results.currencies.CAD.variation)
            variations.append(parsedJSON.results.currencies.AUD.variation)
            variations.append(parsedJSON.results.currencies.JPY.variation)
            variations.append(parsedJSON.results.currencies.CNY.variation)
            variations.append(parsedJSON.results.currencies.BTC.variation)
            
            print(variations)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moedaCell", for: indexPath) as! MoedaTableViewCell

        cell.moedaLabelView.text = currencies[indexPath.row]
        
        if indexPath.row >= 0 && indexPath.row < variations.count {
            DispatchQueue.main.async {
                cell.cotacaoLabelView.text = String(format: "%.2f", self.variations[indexPath.row]) + "%"
            }
        }
        
        if variations[indexPath.row] > 0 {
            cell.cotacaoLabelView.textColor = .green
        } else if variations[indexPath.row] == 0 {
            cell.cotacaoLabelView.textColor = .white
        } else {
            cell.cotacaoLabelView.textColor = .red
        }
        
        cell.moedaView.layer.cornerRadius = 15
        cell.moedaView.layer.borderWidth = 1
        cell.moedaView.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

