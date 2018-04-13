# iOS Image Uploading API

This tutorial uses [Cloudinary](https://cloudinary.com/about). I am in no way affiliated with this company nor do I promote its use over any competing service.

With that said, Cloudinary currently provides free image uploads up to a really big number, and has a top quality developer API with support for iOS, Android, and JavaScript.

This article is focused on iOS. It describe how to: 

  - Setup a Cloudinary account for uploading.

  - Link Cloudinary's binaries into your native iOS build.

  - Provides explination for the [sample code available here](https://bitbucket.org/kezzi-co/lee-kezzi-co).


## Setup 

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


## Link

Setup the Xcode project by creating a new single view app.

Load cloudinary into your project using Cocoapods. If Cocoapods is not installed [install it from cocoapods.org site](https://cocoapods.org/)

From your terminal `cd` to your project's folder 
> you can type cd then drag the folder into your terminal and press return.

enter `pod init` at the terminal. This will create a Podfile

Edit the Podfile by adding `pod 'Cloudinary'` below `use_frameworks!`
```
  use_frameworks!

  pod 'Cloudinary'
```

From your terminal again enter `pod install`

Make sure to close the Xcode project and open the newly created `.xcworkspace` file by Cocoapods.


## Code

Before you can upload anything your app will need to be configured. Using the values you noted from *Setup step 2* fill in this section of [CloudinaryClient.swift](https://bitbucket.org/lee-kezzi-co/image-upload-sample/src/3ea40fb611652ace61fa581276d3e489fb142d7e/image-upload-sample/CloudinaryClient.swift?at=master&fileviewer=file-view-default).
```
    private var apiKey = "< YOUR API KEY HERE >";
    private var apiSecret = "< YOUR API SECRET HERE >";
    private var cloudName = "< YOUR CLOUD NAME HERE >";
```

To upload an image using CloudinaryClient call the static uploadPhoto function from anywhere in your code.
```
    CloudinaryClient.uploadPhoto(image) { url, error in
        print(">>>>>>> \(url)")
    }
```

And voila, an _https_ url for your image is given in the callback function.

The code used to upload the image works by first creating a configuration using a cloudinary URL which is used to setup an Uploader, and then a UIImage is changed to Data format and sent to Cloudinary.

1. Create a new configuration using the values from above.
```
    let url = "cloudinary://\(self.apiKey):\(self.apiSecret)@\(self.cloudName)"
    let config = CLDConfiguration(cloudinaryUrl: url)
```

2. Create a new uploader for every request sent. 
```
        let cld = CLDCloudinary(configuration: config, networkAdapter: nil, sessionConfiguration: nil)
```

3. Change your UIImage into Data as a JPEG or a PNG.
```
    let data = UIImageJPEGRepresentation(image, 0.75)
```

4. uploadPreset should match the value set in *Setup step 4*. Make sure you call back to the main thread before making any changes to the UI.
```
        cld.createUploader().upload(data: data, uploadPreset: "photo-upload", params: nil, progress: { }) { (result, error) in
            DispatchQueue.main.async {
                callback(result?.secureUrl, error)
            }
        }
```


And that's it! you should be ready to create your own app with image uploading capabilities. 

Thank you for reading. Questions and comments to [lee@kezzi.co](mailto:lee@kezzi.co)