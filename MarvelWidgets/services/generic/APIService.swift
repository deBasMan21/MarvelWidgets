//
//  APIService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class APIService {
    static func apiCall<T : Decodable>(url : String, body : [String : Any]?, method : String, as obj: T.Type, auth: String = "") async throws -> T? {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if !auth.isEmpty {
            request.addValue(auth, forHTTPHeaderField: "Authorization")
        }
        
        if body != nil {
            let jsonData = try? JSONSerialization.data(withJSONObject: body!)
            request.httpBody = jsonData
        }
        
        let(data, _) = try await URLSession.shared.data(for: request)
        
        do{
            LogService.log("API call succeeded", in: self)
            
            let decoder = JSONDecoder()
            let model = try decoder.decode(T.self, from: data)
            
            return model
        } catch let parsingError{
            print("error", parsingError)
        }
        
        return nil
    }
}
