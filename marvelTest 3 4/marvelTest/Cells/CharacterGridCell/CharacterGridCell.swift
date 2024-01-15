

import UIKit

protocol CharacterGridCellDelegate: AnyObject {
    func favoriteTapped(characterID: Int, characterName: String)
}


final class CharacterGridCell: UICollectionViewCell {

    @IBOutlet private weak var mContentView: UIView!
    @IBOutlet private weak var characterTitleLabel: UILabel!
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var delegate: CharacterGridCellDelegate?

    private var character: MarvelCharacter?
    private var isLiked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mContentView.layer.borderWidth = 1
        mContentView.layer.borderColor = UIColor.red.cgColor
    }

    override func prepareForReuse() {
        self.characterImageView.image = nil
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let character else { return }
        var myDictionary = UserDefaults.standard.dictionary(forKey: "savedDict") as? [String: Int] ?? [:]
        myDictionary[character.name] = character.id
        UserDefaults.standard.set(myDictionary, forKey: "savedDict")

        self.delegate?.favoriteTapped(characterID: character.id ?? 0, characterName: character.name)
    }

    func loadCharacter(_ character: MarvelCharacter, isLiked: Bool) {
        self.character = character
        self.isLiked = isLiked

        characterTitleLabel.text = character.name
        checkFavorited()

        NetworkHelper.loadImageFromURL(urlString: character.thumbnail.path) { image in
            if let image = image {
                DispatchQueue.main.sync {
                    self.characterImageView.image = image
                }
                return
            }
        }
    }

    private func checkFavorited() {
        guard let character else { return }
    
        favoriteButton.setImage(isLiked ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart") , for: .normal)
     
    }
}
