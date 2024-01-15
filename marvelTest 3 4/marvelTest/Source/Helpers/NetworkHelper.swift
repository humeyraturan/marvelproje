

import Foundation
import UIKit

enum NetworkHelper {
    static func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let imageURLString = "\(urlString)/portrait_xlarge.jpg"
        // URL'yi oluştur
        guard let imageURL = URL(string: imageURLString) else {
            completion(nil)
            return
        }

        // URL'den resmi asenkron olarak yükle
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Resim yüklenirken hata oluştu: \(error)")
                completion(nil)
                return
            }

            // Veriyi kontrol et ve UImage nesnesine dönüştür
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }

        // Görevi başlat
        task.resume()
    }
}
