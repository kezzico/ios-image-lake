//
//  ViewController.swift
//  image-upload-sample
//
//  Created by Lee Irvine on 4/12/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageUrlLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageUrlLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet var didTouchUrl: UITapGestureRecognizer!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if let url = URL(string: self.imageUrlLabel.text) {
            UIApplication.shared.open(url, options: nil, completionHandler: nil)
        }
    }

    @IBAction func didTouchUpload(_ sender: Any) {
        ImagePicker.present(in: self) { image in
            self.imageView.image = image
            self.imageUrlLabel.text = "Uploading..."
            CloudinaryClient.uploadPhoto (image) { url, error in
                if let url = url {
                    self.imageUrlLabel.text = url.absoluteString
                }

                if let error = error {
                    let alert = UIAlertController(title: "!", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))

                    self.present(alert, animated: true, completion: nil)
                    self.imageUrlLabel.text = "error"
                }

            }
        }
    }

}

