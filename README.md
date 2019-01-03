# Upload images to a data lake from iOS using Swift.

This tutorial uses [Cloudinary](https://cloudinary.com/about). I am in no way affiliated with this company nor do I promote its use over any competing service.

With that said, Cloudinary currently provides free image uploads up to a really big number, and has a top quality developer API with support for iOS, Android, and JavaScript.

This article is focused on iOS. It describe how to: 

  - Setup a Cloudinary account

  - Link Cloudinary to your Xcode project

  - Add the Swift code


## Setup a Cloudinary account

1. 
Start by setting up an account on [Cloudinary](https://cloudinary.com/users/register/free).

2. 
Once your account is setup visit the [Cloudinary Console](https://cloudinary.com/console). What's important here is the *Cloud Name*, *API Key*, and *API Secret*. Note these down for later.

![Image](https://bytebucket.org/lee-kezzi-co/image-upload-sample/raw/7886a6f5fd25dd9c42f5e4e0bbff74ac63f33b83/media/cloudinary-api.png#center)


3. 
Next, visit the [Upload Settings page](https://cloudinary.com/console/settings/upload). All of the defaults listed here are fine. Scroll to *Upload Presets* and click *add upload preset* 

![Image](https://bytebucket.org/lee-kezzi-co/image-upload-sample/raw/7886a6f5fd25dd9c42f5e4e0bbff74ac63f33b83/media/add-upload-preset2.png)

4. 
From the *Add Upload* preset screen set the *Preset name* to `photo-upload`, and the *Mode* to unsigned. Further down the page set *Type* to `upload` and *Access Mode* to `public`. Finally, set the *Upload format* to `jpg`

>Public access mode allows anyone with a URL to view the uploaded photo. Authenticated mode will require some changes to the source code. 

>png is also an available upload format if you are planning to upload images with transparency.


## Link Cloudinary to your Xcode project

If Cocoapods is not installed [install it from cocoapods.org site](https://cocoapods.org/)



From a fresh Xcode Project.


From your terminal `cd` to your project's folder 

> TIP: Enter `cd` then drag the folder from finder into your terminal

Next, enter `pod init` from the same terminal. 

The folder should now contain a `Podfile`.

The Podfile is text. Open it with a programmer's text editor. Below where it says `use_frameworks!` add `pod 'Cloudinary'`
```
  use_frameworks!

  pod 'Cloudinary'
```

From your terminal again, enter `pod install`. The folder should now contain an `xcworkspace` file.

## Add the Swift code

Open the `.xcworkspace` with Xcode.

Create a new class. Call it [CloudinaryClient](https://bitbucket.org/lee-kezzi-co/image-upload-sample/src/3ea40fb611652ace61fa581276d3e489fb142d7e/image-upload-sample/CloudinaryClient.swift?at=master&fileviewer=file-view-default).

Using the values from *Setup a Cloudinary account step 2* 

Add this section of .
```
class CloudinaryClient {
    private var apiKey = "< YOUR API KEY HERE >";
    private var apiSecret = "< YOUR API SECRET HERE >";
    private var cloudName = "< YOUR CLOUD NAME HERE >";
```

Let's add a function to CloudinaryClient so that it can be called from anywhere. It will take 2 parameters. The image to upload, and a callback function containing the URL of the image.
```
    CloudinaryClient.uploadPhoto(image) { url, error in
        print(">>>>>>> \(url)")
    }
```
> The image URL will use _https_, so Cloudinary is compatible with Apple's app transporty security policy.

The implementation of UploadPhoto creates a config object, converts the image to a JPEG, and uploads the photo to Cloudinary.

```
    static func uploadPhoto(_ image: UIImage, callback:@escaping (URL?, Error?)->()) {
    // 1. Create a configuration object.
        let url = "cloudinary://\(self.apiKey):\(self.apiSecret)@\(self.cloudName)"
        let config = CLDConfiguration(cloudinaryUrl: url)

    // 2. Create a new uploader for every request sent. 
        let cld = CLDCloudinary(configuration: config, networkAdapter: nil, sessionConfiguration: nil)

    // 3. Change the UIImage to JPEG Data.
        let data = UIImageJPEGRepresentation(image, 0.75)

    // 4. uploadPreset should match the value from *Setup step 4*. 
        let uploadPreset = "photo-upload"
    
    // 5. trigger the upload
        cld.createUploader().upload(data: data, uploadPreset: uploadPreset, params: nil, progress: { }) { (result, error) in
            
    // 6. Call back to the main thread when done.
            DispatchQueue.main.async {
                callback(result?.secureUrl, error)
            }
        }
    }

```


And that's it! you should be ready to create your own app with image uploading capabilities. 

Thank you for reading! Checkout Kezzi.co for other tutorials and code samples.