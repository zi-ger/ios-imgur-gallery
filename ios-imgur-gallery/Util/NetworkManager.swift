//
//  NetworkManager.swift
//  ios-imgur-gallery
//
//  Created by Gustavo Ziger on 01/10/22.
//

import Foundation


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let decoder = JSONDecoder()
    private let apiURL = "https://api.imgur.com/3/gallery/random/random/"
    private let clientId: String = {
        guard let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String else { return "" }
        return clientId
    }()
    
    func fetchImageList(_ pageNumber: Int, completion: @escaping ([Image]) -> Void) {
        if clientId.isEmpty {
            return
        }
        
        guard let url = URL(string: apiURL + "\(pageNumber)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Client-ID \(clientId)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data {
                let imageList = try! self.decoder.decode(ImageData.self, from: data)
                completion(imageList.data)
                return
            }
            completion([])
        }.resume()
    }
    
    func fetchImageDataFromUrl(_ url: String) async -> Data {
        let newUrl = url.replacingOccurrences(of: "http:", with: "https:", options: .literal, range: nil)
        
        guard let url = URL(string: newUrl) else { return Data() }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            return data
        } catch {
            print("Fetch error \(error)")
            return Data()
        }
    }

}
