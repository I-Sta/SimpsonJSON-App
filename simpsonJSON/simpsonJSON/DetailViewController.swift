//
//  DetailViewController.swift
//  simpsonJSON
//
//  Created by Field Employee on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var simpsonName: UILabel!
        
  
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
        if let name = detailItem {
            if let label = simpsonName {
                label.text = name.name
            }
        }
        if let image = detailItem {
            let url = URL(string: image.image)
            guard let sImage = url else{
                return
            }
            if let data = try? Data(contentsOf: sImage) {
                let image2 = UIImage(data: data)
                DispatchQueue.main.async {
                    self.ImageView.image = image2
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
        ImageView.image = UIImage(named: "")
    }

    var detailItem: SimpsonCharact? {
        didSet {
         
            // Update the view.
            configureView()
        }
    }


}

