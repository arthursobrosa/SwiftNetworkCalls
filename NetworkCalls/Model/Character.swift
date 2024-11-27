//
//  Character.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

struct Character: Decodable, CustomStringConvertible {
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var imagePath: String
    
    var imageData: Data?
    
    private enum CodingKeys: String, CodingKey {
        case imagePath = "image"
        case id, name, status, species, gender
    }
    
    var description: String {
        "\(id)-\(name)"
    }
    
    func image() -> UIImage? {
        let defaultImage = UIImage(systemName: "person.fill")
        
        guard let imageData else {
            return defaultImage
        }
        
        return UIImage(data: imageData)
    }
}

struct CharacterResponse: Decodable {
    var results: [Character]
}
