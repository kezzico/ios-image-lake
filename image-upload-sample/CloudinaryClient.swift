//
//  CloudinaryClient.swift
//  image-upload-sample
//
//  Created by Lee Irvine on 4/12/18.
//  Copyright © 2018 kezzi.co. All rights reserved.
//

import UIKit
import Cloudinary

class CloudinaryClient: Any {

    private var apiKey = "< YOUR API KEY HERE >";
    private var apiSecret = "< YOUR API SECRET HERE >";
    private var cloudName = "< YOUR CLOUD NAME HERE >";


    static func uploadPhoto(_ image: UIImage, callback:@escaping (URL?, Error?)->()) {
        let client = CloudinaryClient()

        // Photo is uploaded as JPEG with some minor compression
        let data = UIImageJPEGRepresentation(image, 0.75)
        client.upload(data, preset: "photo-upload") { image, error in
            callback(image, error)
        }
    }

    func upload(_ data: Data?, preset: String, callback:@escaping (URL?, Error?)->()) {
        guard let data = data else {
            return
        }

        let url = "cloudinary://\(self.apiKey):\(self.apiSecret)@\(self.cloudName)"

        guard let config = CLDConfiguration(cloudinaryUrl: url) else {
            print("Invalid cloudinary config: \(url)")
            return
        }

        let cld = CLDCloudinary(configuration: config, networkAdapter: nil, sessionConfiguration: nil)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cld.createUploader().upload(data: data, uploadPreset: preset, params: nil, progress: { progress in
            print("Uploading photo...")
        }) { (result, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var url:URL?

            if let error = error {
                print("error uploading image: \(error)")
            }

            if let httpsUrl = result?.secureUrl {
                print("image uploaded to: \(httpsUrl)")
                url = URL(string: httpsUrl)
            }

            DispatchQueue.main.async {
                callback(url, error)
            }

        }
    }
}

