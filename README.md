![Static Badge](https://img.shields.io/badge/swift-5.8.1-red)
 ![Static Badge](https://img.shields.io/badge/UI-SwiftUI-blue) ![Static Badge](https://img.shields.io/badge/Architecture-MVVM-red) ![Static Badge](https://img.shields.io/badge/Target%20Platforms-iOS%2C%20iPadOS%2C%20macOS-green) ![Static Badge](https://img.shields.io/badge/license-MIT-blue)

 



# Getting Started

Welcome to the Rock, Paper, Scissors game that uses Machine Learning and the Vision framework, allowing users to play using their camera and natural gestures. This app is built in SwiftUI and utilizes Firebase Realtime Database. To enjoy this game, you'll need a device running iOS, iPadOS, or macOS.

# Development

## Libraries used

| Library | Description |
| --- | --- |
| [Firebase](https://firebase.google.com/) | Firebase is a mobile and web application development platform developed by Firebase, Inc. in 2011, then acquired by Google in 2014. |
| [Firebase Realtime Database](https://firebase.google.com/docs/database) | The Firebase Realtime Database is a cloud-hosted database. Data is stored as JSON and synchronized in realtime to every connected client. |
| [Firebase Authentication](https://firebase.google.com/docs/auth) | Firebase Authentication provides backend services, easy-to-use SDKs, and ready-made UI libraries to authenticate users to your app. |
| [Vision](https://developer.apple.com/documentation/vision) | The Vision framework performs face and face landmark detection, text detection, barcode recognition, image registration, and general feature tracking. |
| [CoreML](https://developer.apple.com/documentation/coreml) | Core ML is an Apple framework that allows developers to easily integrate machine learning (ML) models into their apps. |
| [SwiftUI](https://developer.apple.com/documentation/swiftui) | SwiftUI is an innovative, exceptionally simple way to build user interfaces across all Apple platforms with the power of Swift. Build user interfaces for any Apple device using just one set of tools and APIs. |

## Game Mechanics

To play the game, you'll need two players who are logged into the application. One player should send a game invitation to the other player.

Once an invitation is accepted, the camera mode activates, and players need to make a gesture representing their choice. After confirming the chosen gesture, the player sends their choice, which is then compared with the opponent's. The winning player earns 1 point, and the next round begins.

The game continues until one player wins 3 rounds, at which point the game ends, and player statistics are updated.

## Gesture Recognition

This application employs the Vision framework to recognize hands in the camera image. It then sends this data to a custom machine learning algorithm trained specifically for this app. The training database comprises images of hand gestures corresponding to the signs used in Rock Paper Scissors. These images were captured from various angles and lighting conditions. The machine learning model was trained until it achieved a satisfactory level of accuracy.

However, due to variations in lighting and individual hand structures, recognition is not always perfect. To address this, the application includes a display for players to verify that the recognized hand sign matches their intended choice. If the sign is incorrect, players can choose the correct sign from a list of options.

The model is trained using the [CreateML](https://developer.apple.com/documentation/createml) framework. To further improve the model accuracy, the training data can be expanded to include more images.

To learn more about training the models using the Vision framework please refer to the [Apple Developer Documentation](https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml).

The app works without camera access and the user can choose the gesture manually. This is useful if the user doesn't want to grant camera access to the app or if the camera is not available. The user can also choose to play the game using the camera and manually select the gesture if the camera is not able to recognize the gesture. This is especialy useful when using the simulator.

## App UI
The whole user interface is built using SwiftUI. The application is designed to be used on all Apple platforms, including iOS, iPadOS, and macOS. The UI is optimized for all screen sizes and orientations. The application is built using the MVVM architecture. The UI is separated into views and view models. The views are responsible for displaying the data, while the view models handle the logic and data processing. The views and view models are connected using the `@ObservedObject` property wrapper. The views are also connected to the Firebase Realtime Database using the `@StateObject` property wrapper. This ensures that the UI is updated whenever the data changes. The UI is also updated when the user logs in or out of the application. The UI is designed to be intuitive and easy to use. The user can easily navigate between the different screens and access all the features of the application. 



## Firebase Realtime Database

The Firebase Realtime Database comprises the following components:

1. **Games:** This stores all ongoing and completed games.
2. **Players:** Here, player information and online status are recorded.
3. **Statistics:** This section contains player statistics.

The Realtime Database ensures that even if a player disconnects from the game, the current round and score are saved and can be resumed at any time. It also simplifies the process of finding online players.


### API Key

The API key for the Realtime Database is not provided and you will need to add your own. To do so, please follow these steps:

1. Create an account at [Firebase](https://firebase.google.com/).
2. Create a new project.
3. Add an iOS app to the project.
4. Download the `GoogleService-Info.plist` file and add it to the project.
5. In the Firebase console, go to the Realtime Database section and create a new database.
6. In the Rules tab, change the rules to the following:

```
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```
7. Please add the following to the `Info.plist` file:

```
<key>DB_LINK</key>
	<string>https://link-to-database</string>
```

8. Replace `link-to-database` with the link to your database.


## User Management

Upon opening the application, users are greeted with a login screen. If a user doesn't have an account, the sign-up option is available, requiring an email, username, and password for registration. Once registered, the user is automatically logged in.

The authorization process is handled by Firebase Authentication. The user's email and password are stored in the Firebase Authentication section of the Firebase console.



## Multiplayer

After logging in, users have access to two menu screens. One displays games the player was invited to and games they have not finished yet. The other screen lists all online players. To start a game, simply search for an online player and send them a game invitation. Once the invitation is accepted, both players are taken to a new screen to begin the game. If a player disconnects from the game, the game is saved and can be resumed at any time. This way a match can be played over multiple sessions. If a player is offline, the game is saved until they come back online. 

## Statistics

The further development will include a statistics screen, where players can view their win/loss ratio and other information. This data will be stored in the Firebase Realtime Database and is updated after each game.

# Testing

The application was tested on simulators and real devices running iOS, iPadOS, and macOS.

## Unit Testing
For the main models there are unit tests that check the functionality of the models. The tests are located in the `RPS_ML_MultiplayerTests` folder. They mostly check the functionality of the models and the data processing. The tests are written using the `XCTest` framework. The tests can be run by opening the project in Xcode and selecting the `Test` option from the `Product` menu.


# How to use the project

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Complete the setup steps for the Firebase Realtime Database and Firebase Authentication.
4. Run the project on a simulator or real device.
5. Run the project on a second simulator or real device.
6. Log in to both devices using different accounts.
7. On one device, send a game invitation to the other device.
8. Accept the invitation on the second device.
9. Play the game.
10. Enjoy!

If the invitation is not visible on the second device pull down the screen to refresh the list of games. If that doesn't work please check the internet connection and make sure that both devices are logged in to the same account. The game is online and requires an internet connection to work.


# License

License: [MIT](LICENSE)
