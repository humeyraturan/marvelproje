
import Foundation

import UIKit

class CharacterCell: UITableViewCell {
     // Karakterin adını göstermek için label
    
    
    @IBOutlet weak var tblName: UILabel!
    @IBOutlet weak var charImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func favButtonClick(_ favbutton: UIButton) {
        if favbutton.tag == 0 {
            let filledHeartImage = UIImage(systemName: "suit.heart.fill")
            favButton.setImage(filledHeartImage, for: .normal)
            favbutton.tag = 1
            
        } else {
            let emptyHeartImage = UIImage(systemName: "suit.heart")
            favButton.setImage(emptyHeartImage, for: .normal)
            favbutton.tag = 0
        }
    }
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    // Diğer karakter özelliklerini burada 
    
    // Hücre oluşturucu (constructor) method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Label'ı hücreye ekleme ve düzenleme işlemleri burada yapılabilir
        addSubview(nameLabel)
        
        // Label'ın konumlandırılması için constraintler eklenebilir
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        // Diğer karakter özellikleri
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    @IBAction func didTapButton() {
        print(nameLabel.text ?? "boş")
    }
}
