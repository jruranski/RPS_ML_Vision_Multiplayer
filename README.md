# Getting Started

Welcome to the Rock, Paper, Scissors game that uses Machine Learning and Vision, allowing users to play using their camera and natural gestures. This app is built in SwiftUI and utilizes Firebase Realtime Database. To enjoy this game, you'll need a device running iOS.

# Development

## Game Mechanics

To play the game, you'll need two players who are logged into the application. One player should send a game invitation to the other player.

Once an invitation is accepted, the camera mode activates, and players need to make a gesture representing their choice. After confirming the chosen gesture, the player sends their choice, which is then compared with the opponent's. The winning player earns 1 point, and the next round begins.

The game continues until one player wins 3 rounds, at which point the game ends, and player statistics are updated.

## Gesture Recognition

This application employs the Vision framework to recognize hands in the camera image. It then sends this data to a custom machine learning algorithm trained specifically for this app. The training database comprises images of hand gestures corresponding to the signs used in Rock Paper Scissors. These images were captured from various angles and lighting conditions. The machine learning model was trained until it achieved a satisfactory level of accuracy.

However, due to variations in lighting and individual hand structures, recognition is not always perfect. To address this, the application includes a display for players to verify that the recognized hand sign matches their intended choice.

## Firebase Realtime Database

The Firebase Realtime Database comprises the following components:

1. **Games:** This stores all ongoing and completed games.
2. **Players:** Here, player information and online status are recorded.
3. **Statistics:** This section contains player statistics.

The Realtime Database ensures that even if a player disconnects from the game, the current round and score are saved and can be resumed at any time. It also simplifies the process of finding online players.

## User Management

Upon opening the application, users are greeted with a login screen. If a user doesn't have an account, the sign-up option is available, requiring an email, username, and password for registration.

## Multiplayer

After logging in, users have access to two menu screens. One displays games the player was invited to and games they have not finished yet. The other screen lists all online players. To start a game, simply search for an online player and send them a game invitation. Once the invitation is accepted, both players are taken to a new screen to begin the game.
