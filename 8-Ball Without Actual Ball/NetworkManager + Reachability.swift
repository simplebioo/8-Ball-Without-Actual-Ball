//
//  NetworkManager + Reachability.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 12.01.2022.
//

import Foundation
import SystemConfiguration

class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        } ) else {
            return false
        }
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {return false}
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

struct NetworkManager {
    func fetch(compltion: @escaping (Result<ModelAnswer, Error>) -> ()) {
        guard let url = URL(string: "https://8ball.delegator.com/magic/JSON/question_string") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
        
        guard let data = data else { return }

        do {
            let json = try JSONDecoder().decode(ModelAnswer.self, from: data)
            compltion(.success(json))
        } catch {
            print(error)
            compltion(.failure(error))
            }
        }.resume()
    }
}

