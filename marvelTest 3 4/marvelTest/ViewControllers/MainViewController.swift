

import UIKit

enum ListingType {
    case grid
    case list
}

class MainViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var changeViewButton: UIButton!

    // MARK: Defines
    private let titleData:[String] = [ "Su", "Kola", "Gazoz", "Maden Suyu", "Fanta", "Çay", "Kahve"]
    private var listingType: ListingType = .grid


    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
