//
//  APIService.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

class APIService {
    static func apiCall<T : Decodable>(url : String, body : [String : Any]?, method : String, as obj: T.Type, useAuth: Bool = false) async throws -> T? {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if useAuth {
            request.addValue("Bearer 3845c5d0fb08c257c2b4ac20b926763beda3a63b7cbb1c3f5c4df0851300934b77ffb693d8819a4e274f0006554990f3d6354bc43abd65ad218a0d42bb71fc670a5f0a16a631a21efd62bd236dcf876d00e655facc2467fb76181f748395a9481de2890a79c6a909eba44f3df2aecf5ae7830dd1bb83b162372bb4961971eb64", forHTTPHeaderField: "Authorization")
        }
        
        if body != nil {
            let jsonData = try? JSONSerialization.data(withJSONObject: body!)
            request.httpBody = jsonData
        }
        
        let(data, _) = try await URLSession.shared.data(for: request)
        
        do{
            //for logging json responses
//            let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//            LogService.log(jsonResponse, in: self)
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
