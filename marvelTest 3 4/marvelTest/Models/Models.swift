
import Foundation
struct MarvelCharacter: Codable {
  let name: String
  let description: String?
  let thumbnail: Thumbnail
  let series: Series
  let stories: Stories
  let events: Events
  let comics: Comics
  var id: Int?
  var liked: Bool?
}

struct Comics: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Events: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Series: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Stories: Codable {
  let collectionURI: String
  let items: [Item]
}

struct Item: Codable {
  let resourceURI: String
  let name: String
}

struct Thumbnail: Codable {
  let path: String
}

struct CharacterDataWrapper: Codable {
  let data: CharacterDataContainer
}

struct CharacterDataContainer: Codable {
  let results: [MarvelCharacter]
  let offset: Int
  let total: Int

  init(results: [MarvelCharacter], offset: Int, total: Int) {
      self.results = results
      self.offset = offset
      self.total = total
  }
}
