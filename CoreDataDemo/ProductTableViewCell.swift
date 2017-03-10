//
//  ProductTableViewCell.swift
//  CoreDataDemo
//
//  Created by Teewa on 03/03/17.
//  Copyright © 2017 Teewa. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell(product: Product){
        self.productTitleLabel.text = product.productName
        self.productPriceLabel.text = "\(product.productPrice)"
        self.productImageView.image = UIImage(data: product.productImage as! Data)
    }
}
