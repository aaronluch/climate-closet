# ClimateCloset

ClimateCloset is an iOS app designed to help users manage their wardrobe and plan outfits based on weather data. The app includes features like outfit sharing, real-time updates, and user authentication.

---

## Features

- **Wardrobe Management:** Add and organize clothing items.
- **Outfit Planning:** Create outfits with thumbnails and save them.
- **Weather Integration:** Real-time weather with the OpenWeatherAPI data.
- **Social Feed:** Share and browse outfits with other users.
- **Camera & Photo Library Support:** Add clothing items with photos.

---

## Getting Started

### Prerequisites
- **Xcode 14+**
- **CocoaPods** (if dependencies are not pre-installed):
  ```bash
  sudo gem install cocoapods

---

## Setup
- Clone the repository
  ```
  git clone https://github.com/aaronluch/climate-closet.git
- Launch through the 'climate-closet.xcworkspace' file

- If encountering issues with Firebase, try reinstalling the pods
  ```
  cd climate-closet
  pod install

- If you cannot install pods via ```pod install``` you must install the latest version of CocoaPods stated in Prerequisites.

- Run the app: Select a simulator or device in Xcode, then build and run the projec

---

## Testing Notes

### Location Services
- On the simulator, enable location services under: Simulator → Features → Location and select a location (the app allows for getting actual location, the simulator has issues understanding permissions though.)
- On a physical device, ensure location permissions are granted in settings.
  
