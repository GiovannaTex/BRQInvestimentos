//
//  ViewController.swift
//  BRQInvestimentos
//
//  Created by user on 09/09/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    // MARK: Properties
    var isoMoedas = ["USD", "EUR", "GBP", "ARS", "CAD", "AUD", "JPY", "CNY", "BTC"]
    var moedas = [Currency]()
    
    let urlString = "https://api.hgbrasil.com/finance?key=ddc1480f"
    //let urlString = "https://api.hgbrasil.com/finance"
        
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        title = "Moedas"
        
        carregarMoedas()
    }
    
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isoMoedas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moedaCell", for: indexPath) as! MoedaTableViewCell

        // ISO
        cell.moedaLabelView.text = isoMoedas[indexPath.row]
        
        // variação
        if indexPath.row >= 0 && indexPath.row < moedas.count {
            
            let formatoNumeros = NumberFormatter()
            
            formatoNumeros.numberStyle = .decimal
            formatoNumeros.decimalSeparator = ","
            formatoNumeros.groupingSeparator = "."
            
            if let variacao = moedas[indexPath.row].variation as NSNumber? {
                if var variacaoString = formatoNumeros.string(from: variacao) {
                    while variacaoString.last == "0" {
                        variacaoString.removeLast()
                    }
                    if variacaoString.last == "," {
                        variacaoString.removeLast()
                    }
                    
                    cell.cotacaoLabelView.text = variacaoString + "%"
                }
            }
            
            if moedas[indexPath.row].variation > 0 {
                cell.cotacaoLabelView.textColor = .green
            } else if moedas[indexPath.row].variation == 0 {
                cell.cotacaoLabelView.textColor = .white
            } else {
                cell.cotacaoLabelView.textColor = .red
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
        if let vc = storyboard?.instantiateViewController(withIdentifier: "cambioVC") as? CambioViewController {
            vc.isoMoeda = isoMoedas[indexPath.row]
            vc.moeda = moedas[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

