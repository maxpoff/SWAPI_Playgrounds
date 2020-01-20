import UIKit

struct Person: Decodable {
    
    var name: String
    var films: [URL]
    
}//End of struct

struct Film: Decodable {
    
    var title: String
    var opening_crawl: String
    var release_date: String
    
}//End of struct

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personComponentPath = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else {return completion(nil)}
        let personURL = baseURL.appendingPathComponent(personComponentPath)
        let finalURL = personURL.appendingPathComponent(String(id))
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else {
                return completion(nil)
            }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url ) { (data, _, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else {
                return completion(nil)
            }
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
        }.resume()
    }
    
}//End of class

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 3) { (person) in
    print(person?.name)
    if let person = person {
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

