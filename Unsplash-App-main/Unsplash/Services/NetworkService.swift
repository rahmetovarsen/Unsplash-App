import UIKit

protocol NetworkingService {
    func fetchDataWithQuery(query: String)
    func fetchDataWithId(id: String, completion: @escaping(Photo?)->Void)
    func configureImage(with url: String, completion: @escaping (UIImage) -> Void)
}

final class NetworkingServiceImplementation: NetworkingService {
    
    private let api = "aj4MxWjGdmF02tE2DVjPLBUv1GwPRgtgfpeDnOh78nM"
    
    func fetchDataWithQuery(query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(query)&client_id=" + api
        
        guard let url = URL(string: urlString) else {
            return
        }
        let group = DispatchGroup()
        group.enter()
        
        let task = URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                group.leave()
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("\(error.localizedDescription)")
            }
            guard let result = result else {
                group.leave()
                return
            }
            PhotoCollection.photoCollection = result.results
            group.leave()
        }
        
        task.resume()
        group.wait()
        return
    }
    
    func fetchDataWithId(id: String, completion: @escaping(Photo?)->Void ) {
        let group = DispatchGroup()
        group.enter()
        let urlString = "https://api.unsplash.com/photos/\(id)?client_id=" + api
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {  data, response, error in
            guard let data = data, error == nil else {
                return
            }
            var result: Photo?
            do {
                result = try JSONDecoder().decode(Photo.self, from: data)
            }
            catch {
                print("\(error)")
            }
            guard let result = result else {
                return
            }
            completion(result)
            group.leave()
        }
        
        task.resume()
        group.wait()
        return
    }
    
    func configureImage(with url: String, completion: @escaping (UIImage) -> Void){
        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {  data, _, error in
            guard let data = data, error == nil else {
                return
            }
                let image = UIImage(data: data)
                DispatchQueue.main.async{
                    if let image = image {
                        completion(image)
                    }
                }
        }
        task.resume()
    }
}
