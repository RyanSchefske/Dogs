//
//  DogViewController.swift
//  Dogs
//
//  Created by Ryan Schefske on 12/16/19.
//  Copyright © 2019 Ryan Schefske. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {

    @IBOutlet var dogBreed: UILabel!
    @IBOutlet var dogImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignbackground()
        randomDog()
        
    }
    
    @IBAction func newDogClicked(_ sender: Any) {
        randomDog()
    }
    
    func randomDog() {
        if let url = URL(string: "https://dog.ceo/api/breeds/image/random") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let dataReceived = data, error == nil else {
                    print(error?.localizedDescription ?? "Receive Error")
                    return
                }
                
                let decoder = JSONDecoder()
                let imageData = try! decoder.decode(DogImage.self, from: dataReceived)
                let split = imageData.message.components(separatedBy: "/")
                DispatchQueue.main.async {
                    self.dogBreed.text = split[4]
                }
                self.getImage(imageString: imageData.message)
                
            }.resume()
        }
    }
    
    func getImage(imageString: String) {
        if let imageUrl = URL(string: imageString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard let data = data else {
                    return
                }
                let downloadedImage = UIImage(data: data)
                DispatchQueue.main.async {
                    self.dogImage.image = downloadedImage
                }
            }.resume()
        }
    }
    
    func assignbackground(){
        let background = UIImage(named: "PawPrint")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
}
