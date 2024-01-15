
import UIKit

protocol CharacterListCellDelegate: AnyObject {
    func favoriteButtonTappedOnListCell(id: Int, name: String)
}

class CharacterListCell: UICollectionViewCell {

    // Outlets
    @IBOutlet private weak var mContentView: UIView!
    @IBOutlet private weak var characterNameLabel: UILabel!
    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!

    private var character: MarvelCharacter?
    private var isLiked: Bool = false
    weak var delegate: CharacterListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mContentView.layer.borderWidth = 1
        mContentView.layer.borderColor = UIColor.blue.cgColor
    }

    override func prepareForReuse() {
        self.characterImageView.image = nil
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let character else { return }
        var myDictionary = UserDefaults.standard.dictionary(forKey: "savedDict") as? [String: Int] ?? [:]
        myDictionary[character.name] = character.id
        UserDefaults.standard.set(myDictionary, forKey: "savedDict")
      
        self.delegate?.favoriteButtonTappedOnListCell(id: character.id ?? 0, name: character.name)
    }

    func loadCharacter(_ character: MarvelCharacter, isLiked: Bool) {
        characterNameLabel.text = character.name
        self.character = character
        self.isLiked = isLiked
        
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
        
        favoriteButton.setImage(isLiked ? UIImage(systemName: "heart.fill") :  UIImage(systemName: "heart") , for: .normal)
    }
}
