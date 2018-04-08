//
//  ImageManager.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 29.03.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImageManager {

    static func getImageForManagedObject(into context: NSManagedObjectContext, from url: URL, completion: @escaping (UIImage?) -> Void) {
        downloadImage(from: url) { image in
            context.performChanges {
                completion(image)
            }
        }
    }

    static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return completion(nil)
            }

            completion(image)
        }.resume()
    }

    /*
    func add(image: UIImage, name: String) -> String? {
        let imageUrl = documentsUrl.appendingPathComponent("\(name).png")

        /*
        do {
            let files = try fileManager.contentsOfDirectory(atPath: documentsUrl.path)

            if files.contains(where: {
                let tempUrl = documentsUrl.appendingPathComponent($0)
                return tempUrl.path == imageUrl.path
            }) {
                try fileManager.removeItem(atPath: imageUrl.path)
            }


        } catch {
            print("Error: \(error)")
            return nil
        } */

        guard let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }

        do {
            try imageData.write(to: imageUrl, options: .atomic)
        } catch {
            print("Error: \(error)")
            return nil
        }

        return imageUrl.path
    } */

}
