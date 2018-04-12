# iOS Image Uploading API

This tutorial uses [Cloudinary](https://cloudinary.com/about). I am in no way affiliated with this company nor do I promote its use over any competing service.

With that said, Cloudinary currently provides free image uploads up to a really big number, and has a top quality developer API with support for iOS, Android, and JavaScript.

This article is focused on iOS. It describe how to: 

  - Setup a Cloudinary account for uploading.

  - Link Cloudinary's binaries into your native iOS build.

  - Provides explination of the [sample code available here](https://bitbucket.org/kezzi-co/lee-kezzi-co).


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

>Public access mode allows anyone with a URL to view the uploaded photo. Authenticated access will only require some minor tweaks to the source code. 

>png is also an available upload format if you are planning to upload images with transparency.


## Link

Setup the Xcode project by creating a new single view app.

Load cloudinary into your project using Cloudinary. If Cocoapods is not installed [install it from cocoapods.org site](https://cocoapods.org/)

From your terminal `cd` to your project's folder 
> you can type cd then drag the folder into your terminal and press return.

enter `pod init` at the terminal. This will create a Podfile

Edit the Podfile by adding `pod 'Cloudinary'` below `use_frameworks!`
```
  use_frameworks!

  pod 'Cloudinary'
```

From your terminal again enter `pod install`

Make sure to close the Xcode project and open the .xcworkspace file Cocoapods has created


## Code

As of writing this, I have not been able to successfully use Cloudinary through Swift, so let's make a bridging header.

image-upload-sample-Bridging-Header.h
```
//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "CloudinaryClient.h"
```



The photo is uploaded as a JPEG image with minor compression
```
    let data = UIImageJPEGRepresentation(image, 0.75)
    client.upload(data, "photo-upload")
```

