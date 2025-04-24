//
//  ContactTVCell.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//

import UIKit

class ContactTVCell: UITableViewCell {
    
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var avtarimg: UIImageView!
    
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emaillable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(data : DataModel) {
        self.namelable.text = "First Name: \(data.first_name ?? "")"
        self.lastNameLabel.text = "Last Name: \(data.last_name ?? "")"
        self.emaillable.text = "Email: \(data.email ?? "")"
        Helper.getImgFromUrl(imgView: self.avtarimg, url: data.avatar ?? "")
        self.avtarimg.layer.cornerRadius = self.avtarimg.frame.height / 2
        self.bgview.layer.cornerRadius = 10
    }
}
