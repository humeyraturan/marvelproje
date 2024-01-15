
import UIKit


final class DetailViewController: UIViewController {

    @IBOutlet weak var lbl_Comics: UILabel!
    @IBOutlet weak var lbl_Series: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_Stories: UILabel!
    @IBOutlet weak var lbl_Events: UILabel!
    var img = UIImage()
    var user_name = ""
    var series = ""
    var stories = ""
    var events = ""
    var comics = ""

    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daha Fazla", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moreButtonComics: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daha Fazla", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moreButtonEvents: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daha Fazla", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moreButtonStories: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Daha Fazla", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_Name.text = user_name
        lbl_Series.text = series
        img_View.image = img
        lbl_Stories.text = stories
        lbl_Events.text = events
        lbl_Comics.text = comics
        
        view.addSubview(moreButton)
        view.addSubview(moreButtonComics)
        view.addSubview(moreButtonEvents)
        view.addSubview(moreButtonStories)

        NSLayoutConstraint.activate([

            moreButton.topAnchor.constraint(equalTo: lbl_Series.bottomAnchor, constant: 8),
            moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([

                    moreButtonComics.topAnchor.constraint(equalTo: lbl_Comics.bottomAnchor, constant: 8),
                    moreButtonComics.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                ])
        
        NSLayoutConstraint.activate([

                    moreButtonEvents.topAnchor.constraint(equalTo: lbl_Events.bottomAnchor, constant: 8),
                    moreButtonEvents.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                ])
        
        NSLayoutConstraint.activate([

                    moreButtonStories.topAnchor.constraint(equalTo: lbl_Stories.bottomAnchor, constant: 8),
                    moreButtonStories.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                ])


        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        moreButtonComics.addTarget(self, action: #selector(moreButtonComicsTapped), for: .touchUpInside)
        moreButtonStories.addTarget(self, action: #selector(moreButtonStoriesTapped), for: .touchUpInside)
        moreButtonEvents.addTarget(self, action: #selector(moreButtonEventsTapped), for: .touchUpInside)
        configureLabels()
    }
     
    // Data olmayanlarda gelen uyarı
    
    private func configureLabels() {
        if series == "" {
            lbl_Series.text = "No Series Data"
            moreButton.isHidden = true
           lbl_Series.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if stories == "" {
            lbl_Stories.text = "No Stories Data"
            moreButtonComics.isHidden = true
            lbl_Stories.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if comics == "" {
            lbl_Comics.text = "No Comics Data"
            moreButtonStories.isHidden = true
            lbl_Comics.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if events == "" {
            lbl_Events.text = "No Events Data"
            moreButtonEvents.isHidden = true
            lbl_Events.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    
    
    @objc func moreButtonTapped() {
        if lbl_Series.numberOfLines == 0 {
           // Eğer tam metin gösteriliyorsa, metni kırp
            
            lbl_Series.numberOfLines = 2 // ya da başka bir sayı
            moreButton.setTitle("Daha Fazla", for: .normal)
        } else {
            // Eğer kırpılmış metin gösteriliyorsa, tam metni göster
            lbl_Series.numberOfLines = 0
            moreButton.setTitle("Daha Az", for: .normal)
        }
    }
    
    @objc func moreButtonComicsTapped() {
        if lbl_Comics.numberOfLines == 0 {
            // Eğer tam metin gösteriliyorsa, metni kırp
            lbl_Comics.numberOfLines = 2 // ya da başka bir sayı
            moreButtonComics.setTitle("Daha Fazla", for: .normal)
        } else {
            // Eğer kırpılmış metin gösteriliyorsa, tam metni göster
            lbl_Comics.numberOfLines = 0
            moreButtonComics.setTitle("Daha Az", for: .normal)
        }
    }
    
    @objc func moreButtonStoriesTapped() {
        if lbl_Stories.numberOfLines == 0 {
            // Eğer tam metin gösteriliyorsa, metni kırp
            lbl_Stories.numberOfLines = 2 // ya da başka bir sayı
            moreButtonStories.setTitle("Daha Fazla", for: .normal)
        } else {
            // Eğer kırpılmış metin gösteriliyorsa, tam metni göster
            lbl_Stories.numberOfLines = 0
            moreButtonStories.setTitle("Daha Az", for: .normal)
        }
    }
    
    @objc func moreButtonEventsTapped() {
        if lbl_Events.numberOfLines == 0 {
            // Eğer tam metin gösteriliyorsa, metni kırp
            lbl_Events.numberOfLines = 2 // ya da başka bir sayı
            moreButtonEvents.setTitle("Daha Fazla", for: .normal)
        } else {
            // Eğer kırpılmış metin gösteriliyorsa, tam metni göster
            lbl_Events.numberOfLines = 0
            moreButtonEvents.setTitle("Daha Az", for: .normal)
        }
    }
    


}
