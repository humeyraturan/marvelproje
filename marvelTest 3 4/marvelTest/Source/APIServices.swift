
import Foundation

class APIServices {
    
    public init(){}
    
    private var apiBaseURL = "https://gateway.marvel.com:443/v1/public/characters?ts=1690482116&apikey=3e3cfb2ebfc3dac4d734c0da13ab425c&hash=215b9cf7391359982b009d204bfbfcf4"
    
    
    var limit = 20
    
    func fetchingApiData(page: Int, orderBy: String, completion: @escaping ([MarvelCharacter], Int) -> Void) {
        let urlString = "\(apiBaseURL)&offset=\(page * limit)&limit=\(limit)&orderBy=\(orderBy)"
        print("URL string is now \(urlString)")
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Geçersiz yanıt.")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let characterDataWrapper = try decoder.decode(CharacterDataWrapper.self, from: data)
                    
                    let characters = characterDataWrapper.data.results
                    let total = characterDataWrapper.data.results.count
                    print("fetchingApiData Cevabı:")
                    completion(characters, total)
                } catch {
                    print("JSON dönüştürme hatası: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchingSearchApiData(
        nameStartsWith: String,
        page: Int,
        orderBy: String,
        completion: @escaping ([MarvelCharacter], Int) -> Void) {
        let urlString = "\(apiBaseURL)&nameStartsWith=\(nameStartsWith)&limit=100&orderBy=\(orderBy)"
        print("URL string is now \(urlString)")
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Geçersiz yanıt.")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let characterDataWrapper = try decoder.decode(CharacterDataWrapper.self, from: data)
                    
                    let characters = characterDataWrapper.data.results
                    let total = characterDataWrapper.data.results.count
                    print("Search API Cevabı: count: \(total)")
                    completion(characters, total)
                } catch {
                    print("JSON dönüştürme hatası: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    
    func getCharacterByID(id: Int, completion: @escaping (MarvelCharacter, Int) -> Void) {
        let urlString = "https://gateway.marvel.com:443/v1/public/characters/\(id)?ts=1690482116&apikey=3e3cfb2ebfc3dac4d734c0da13ab425c&hash=215b9cf7391359982b009d204bfbfcf4&offset=10&limit=10&orderBy=name"
        print("URL string is now \(urlString)")
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }
        guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Geçersiz yanıt.")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let characterDataWrapper = try decoder.decode(CharacterDataWrapper.self, from: data)
                    
                    let characters = characterDataWrapper.data.results
                    let total = characterDataWrapper.data.results.count
                    print("fetchingApiData Cevabı:")
                    completion(characters.first!, total)
                } catch {
                    print("JSON dönüştürme hatası: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
}

