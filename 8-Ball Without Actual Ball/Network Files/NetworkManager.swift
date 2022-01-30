//
//  NetworkManager + Reachability.swift
//  8-Ball Without Actual Ball
//
//  Created by Bioo on 12.01.2022.
//

import Foundation

struct NetworkManager {
    func fetchAnswer(compltion: @escaping (Result<AnswerModel, Error>) -> ()) {
        guard let url = URL(string: "https://8ball.delegator.com/magic/JSON/question_string") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
        
        guard let data = data else { return }

        do {
            let json = try JSONDecoder().decode(AnswerModel.self, from: data)
            compltion(.success(json))
        } catch {
            print(error)
            compltion(.failure(error))
            }
        }.resume()
    }
}

