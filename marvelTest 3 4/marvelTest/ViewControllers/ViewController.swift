

import UIKit



final class ViewModel {
    var integerArray: [Int] = []
    var savedData: [String: Int] = [:]
    var characters = [MarvelCharacter]()
    var filteredChars: [MarvelCharacter] = []
    var searchChars: [MarvelCharacter] = []
    var isFetchingData = false
    var currentPage = 1
    var searchText = ""
    private var listingType: ListingType = .grid
    var isFiltered: Bool = false
    var orderByParameter = "name"
   
}


final class ViewController: UIViewController, UISearchBarDelegate {
    
 
    var characters = [MarvelCharacter]()
    var filteredChars: [MarvelCharacter] = []
    var searchChars: [MarvelCharacter] = []
    var isFetchingData = false
    var currentPage = 1
    var searchText = ""
    private var listingType: ListingType = .grid
    var isFiltered: Bool = false
    var orderByParameter = "name"
   
    let viewModel = ViewModel()
    var apiServices = APIServices()
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var btnFavorite: UIButton!
    @IBOutlet private weak var btnOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initializeCollectionView()
        addNavbarButtons()
        configureSearchBar()
        fetchData()
        configureSaved()
       
    }
    private func configureSaved() {
        viewModel.savedData = UserDefaults.standard.value(forKey: "savedDict") as? [String: Int] ?? [:]
        viewModel.integerArray = Array(viewModel.savedData.values)
        
    }

    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
    }
    
    private func fetchData() {
       if let charDict = UserDefaults.standard.dictionary(forKey: "savedDict") as? [String: Int] {
    
           self.viewModel.savedData = charDict
        }
     
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        apiServices.fetchingApiData(
                                          page: self.currentPage,
                                          orderBy: orderByParameter){ data, response  in
            
                
            print("init page data \(data.count)")
            self.characters.removeAll()
            self.characters = data
            
            self.filteredChars.removeAll()
            self.filteredChars.append(contentsOf: self.characters)
           
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    private func addNavbarButtons() {
        let changeView = UIBarButtonItem(image: UIImage(systemName: "arrow.left.arrow.right") , style: .plain, target: self, action: #selector(changeView))
        let favoriteList = UIBarButtonItem(title: "Favoriler" , style: .plain, target: self, action: #selector(showFavorite))
        navigationItem.rightBarButtonItem = changeView
        navigationItem.leftBarButtonItem = favoriteList
    }

    private func initializeCollectionView() {
        collectionView.register(.init(nibName: "CharacterGridCell", bundle: nil), forCellWithReuseIdentifier: "CharacterGridCell")
        collectionView.register(.init(nibName: "CharacterListCell", bundle: nil), forCellWithReuseIdentifier: "CharacterListCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @objc private func changeView() {
        // Bu fonksiyon çalıştığında ekran değişecek.
        if listingType == .grid {
            self.listingType = .list
            self.collectionView.reloadData()
        } else {
            self.listingType = .grid
            self.collectionView.reloadData()
        }
    }
    
    
    @objc private func showFavorite() {
        self.isFiltered = !self.isFiltered

        if isFiltered {
            navigationItem.leftBarButtonItem?.title = "Tümü"
            
            filteredChars.removeAll()
            viewModel.savedData = UserDefaults.standard.value(forKey: "savedDict") as? [String: Int] ?? [:]
            
            viewModel.savedData.values.forEach { id in
                
                apiServices.getCharacterByID(id: id){data,response in

                    DispatchQueue.main.async {
                        self.filteredChars.append(data)
                        self.searchChars.append(data)
                        print("List count \(self.filteredChars.count)")
                        self.collectionView.reloadData()
                    }
                }
                
            }
            
        } else {
            navigationItem.leftBarButtonItem?.title = "Favoriler"
            filteredChars = characters
        }
        
       
        collectionView.reloadData()
    }
    
    // Alfabetik sıralama
    @IBAction func orderButtonTapped(_ sender: Any) {
       
        
            if orderByParameter == "name" {
                orderByParameter = "-name"
                btnOrder.setTitle("Z-A", for: .normal)
            } else {
                orderByParameter = "name"
                btnOrder.setTitle ("A-Z", for: .normal)
            }
        
        searchBar.text = ""
            //filteredChars.removeAll()
            self.currentPage = 1
        
        if self.isFiltered {
            filteredChars.reverse()
        }else {
         
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            apiServices.fetchingApiData(page: self.currentPage,
                                              orderBy: orderByParameter){ data, response  in
                
                print("orderButtonTapped \(data.count)")
                
                self.characters = data
                
                self.filteredChars.removeAll()
                self.filteredChars.append(contentsOf: self.characters)
               
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredChars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isFiltered, indexPath.item + 2 == filteredChars.count {
            fetchNextPage()
        }

        if self.listingType == .grid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterGridCell", for: indexPath)  as! CharacterGridCell
            cell.loadCharacter(filteredChars[indexPath.item],
                               isLiked: self.getLikeStatus(forCharacterID: filteredChars[indexPath.item].id))
            cell.delegate = self
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterListCell", for: indexPath)  as! CharacterListCell
        cell.loadCharacter(filteredChars[indexPath.item],
                           isLiked: self.getLikeStatus(forCharacterID: filteredChars[indexPath.item].id))
        cell.delegate = self
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.listingType == .grid {
            return .init(width: 120, height: 215)
        }

        return .init(width: self.view.bounds.width - 20, height: 150)

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var character = filteredChars[indexPath.item]
               character.id = indexPath.item
               //cell.tblName.text = character.name
        print("selected cell \(indexPath.item)" + character.name)
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController{

            NetworkHelper.loadImageFromURL(urlString: character.thumbnail.path) { image in
                if let image {
                    vc.img = image
                }
            }
            //vc.img = UIImage(named: character.thumbnail.path)!
            vc.user_name = filteredChars[indexPath.item].name
            let seriesNames = characters[indexPath.row].series.items.map { $0.name }
            let combinedNames = seriesNames.joined(separator: ", ")
            vc.series = combinedNames

            let storyNames = filteredChars[indexPath.item].stories.items.map { $0.name }
            let combinedStoryNames = storyNames.joined(separator: ", ")
            vc.stories = combinedStoryNames

            let eventNames = filteredChars[indexPath.item].events.items.map { $0.name }
            let combinedEventNames = eventNames.joined(separator: ", ")
            vc.events = combinedEventNames

            let comicNames = filteredChars[indexPath.item].comics.items.map { $0.name }
            let combinedComicNames = comicNames.joined(separator: ", ")
            vc.comics = combinedComicNames

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: CharacterGridCellDelegate, CharacterListCellDelegate {
  
    func favoriteTapped(characterID: Int, characterName: String) {
        handleClick(characterID: characterID)
        self.collectionView.reloadData()
    }

    func favoriteButtonTappedOnListCell(id: Int, name: String) {
        handleClick(characterID: id)
        self.collectionView.reloadData()
    }
}

extension ViewController {

    func fetchNextPage() {
        print("NExtPage")
       
            if !(isFiltered) {
                DispatchQueue.global().sync {
                    self.isFetchingData = true
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = false
                        self.activityIndicator.stopAnimating()
                    }
                    
                    if self.characters.count > 0 {
                        currentPage = self.characters.count / self.apiServices.limit + 1
                    }
                        apiServices.fetchingApiData(page: currentPage, orderBy: orderByParameter){data,total in
                        
                            self.currentPage += 1
                          
                                          self.characters.append(contentsOf: data)
                                          self.filteredChars = self.characters
                                          //self.likes = [String](repeating:"unlike", count: self.filteredChars.count)
                          
                                          DispatchQueue.main.async {
                                              self.collectionView.reloadData()
                                              // API isteği tamamlandığında ActivityIndicator'ı gizle
                                              self.activityIndicator.isHidden = true
                                              self.activityIndicator.stopAnimating()
                                          }
                                          self.isFetchingData = false
                        }
                }
            }
        
    }
}


extension ViewController {
    func handleClick(characterID: Int) {
       
        let savedData = UserDefaults.standard.value(forKey: "savedDict") as? [String: Int]
        
        if let saved = savedData {
            if saved.values.contains(characterID) {
                viewModel.integerArray.removeAll { $0 == characterID }
            } else {
                viewModel.integerArray.append(characterID)
            }
        }

    }
    
    func getLikeStatus(forCharacterID characterID: Int?) -> Bool {
        
        viewModel.integerArray.contains(characterID ?? -10)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("Enter tuşuna basıldı!")
        searchText  = searchBar.text ?? ""
        currentPage = 1
     
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
   
        if navigationItem.leftBarButtonItem?.title == "Tümü" {
            let savedData = UserDefaults.standard.value(forKey: "savedDict") as? [String: Int]
            let filtered = savedData?.keys.filter({ $0.lowercased().contains(searchText.lowercased())})
            
            if let keys = filtered, !keys.isEmpty {
                let filteredValues = keys.compactMap { savedData?[$0] }
                viewModel.integerArray = filteredValues
                print(viewModel.integerArray)
                
                viewModel.integerArray.forEach { id in
                    
                 
                    self.filteredChars.removeAll()
                    
                    apiServices.getCharacterByID(id: id){data,response in

                        DispatchQueue.main.async {
                            
                            self.filteredChars.append(data)
                            self.searchChars.append(data)
                            print("List count \(self.filteredChars.count)")
                            self.collectionView.reloadData()
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
               
                print("Filtrelenmiş Değerler: \(filteredValues)")
            } else {
                print("Filtrelenmiş veri bulunamadı.")
            }
          
            
           
        } else {
            if searchText.isEmpty {
                isFiltered = false
                apiServices.fetchingApiData(
                                                  page: self.currentPage,
                                                  orderBy: orderByParameter){ data, response  in
                    
                        
                    print("init page data \(data.count)")
                    self.characters.removeAll()
                    self.characters = data
                    
                    self.filteredChars.removeAll()
                    self.filteredChars.append(contentsOf: self.characters)
                   
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            } else {
                isFiltered = true
                apiServices.fetchingSearchApiData(nameStartsWith: searchText.trimmingCharacters(in: .whitespacesAndNewlines), page: currentPage, orderBy: orderByParameter){ data, response  in
                    
                    print("orderButtonTapped \(data.count)")
                    self.characters.removeAll()
                    self.characters = data
                    
                    self.filteredChars.removeAll()
                    self.filteredChars.append(contentsOf: self.characters)
                   
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
      
    }
}

