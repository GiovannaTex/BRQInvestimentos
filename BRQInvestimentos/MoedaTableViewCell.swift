//
//  MoedaTableViewCell.swift
//  BRQInvestimentos
//
//  Created by user on 10/09/21.
//

import UIKit

class MoedaTableViewCell: UITableViewCell {
    
    @IBOutlet var moedaView: UIView!
    @IBOutlet var moedaLabelView: UILabel!
    @IBOutlet var cotacaoLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
