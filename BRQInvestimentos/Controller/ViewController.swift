//
//  ViewController.swift
//  BRQInvestimentos
//
//  Created by user on 09/09/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    // MARK: Propriedades
    var isoMoedas = ["USD", "EUR", "GBP", "ARS", "CAD", "AUD", "JPY", "CNY", "BTC"]
    var moedas = [Currency]()
    var saldo = Saldo()
    
    let urlString = "https://api.hgbrasil.com/finance?key=ddc1480f"
    
    let formatoNumeros: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        return formatter
    }()
        
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        title = "Moedas"
        
        carregarMoedas()
    }
    
    // MARK: Dados
    func carregarMoedas() {
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(Entry.self, from: data)
                    
                    self.moedas.append(parsedJSON.results.currencies.USD)
                    self.moedas.append(parsedJSON.results.currencies.EUR)
                    self.moedas.append(parsedJSON.results.currencies.GBP)
                    self.moedas.append(parsedJSON.results.currencies.ARS)
                    self.moedas.append(parsedJSON.results.currencies.CAD)
                    self.moedas.append(parsedJSON.results.currencies.AUD)
                    self.moedas.append(parsedJSON.results.currencies.JPY)
                    self.moedas.append(parsedJSON.results.currencies.CNY)
                    self.moedas.append(parsedJSON.results.currencies.BTC)
                    
                    print(self.moedas)
                        
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isoMoedas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moedaCell", for: indexPath) as! MoedaTableViewCell

        // ISO
        cell.moedaLabelView.text = isoMoedas[indexPath.row]
        
        // variação
        if indexPath.row >= 0 && indexPath.row < moedas.count {
            
            if let variacao = moedas[indexPath.row].variation as NSNumber? {
                if let variacaoString = formatoNumeros.string(from: variacao) {
                    cell.cotacaoLabelView.text = variacaoString + "%"
                }
            }
            
            if moedas[indexPath.row].variation > 0 {
                cell.cotacaoLabelView.textColor = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.0)
            } else if moedas[indexPath.row].variation == 0 {
                cell.cotacaoLabelView.textColor = .white
            } else {
                cell.cotacaoLabelView.textColor = UIColor(red: 0.815, green: 0.007, blue: 0.105, alpha: 1.0)
            }
        }
        
        cell.moedaView.layer.cornerRadius = 15
        cell.moedaView.layer.borderWidth = 1
        cell.moedaView.layer.borderColor = UIColor.white.cgColor
        cell.moedaView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let storyboard = storyboard,
              let nc = navigationController
        else { return }
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "cambioVC") as? CambioViewController {
            vc.isoMoeda = isoMoedas[indexPath.row]
            vc.moeda = moedas[indexPath.row]
            vc.saldo = saldo
            vc.formatoNumeros = formatoNumeros
            nc.pushViewController(vc, animated: true)
        }
    }
}

