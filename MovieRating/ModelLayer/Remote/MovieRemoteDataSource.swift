//
//  MovieRemoteDataSource.swift
//  MovieRating
//
//  Created by 혜리 on 2023/05/15.
//

import Foundation

class MovieRemoteDataSource {
    
    static let shared = MovieRemoteDataSource()
    
    var urlComponents: URLComponents!
    
    private init() {
        urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3/search/movie"
    }
    
    func getMovieList(query: String, page: String, callback: @escaping (Response) -> Void) {
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "73861d304f91be437d4465b52141a39b"),
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: page)
        ]
        
        guard let url = urlComponents.url else {
            print("유효하지 않은 URL: \(urlComponents.debugDescription)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data)
                
                DispatchQueue.main.async {
                    callback(response)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
