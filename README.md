# Pitchfork Client App

An app designed to get data from pitchfork and bundle it up inside a mobile app

## Technologies

- Webscraping: **Pitchfork.com using Python**
- Backend: **Firebase Realtime Database**
- Frontend: **Flutter**

## How to run it

1. Clone the repo
2. Create a virtual enviorment
   1. `virtualenv pitchfork-webscrape`
   2. `source pitchfork-webscrape/bin/activate`
3. Install the dependencies
   - `pip install -r requirements.txt` 
4. Start flask app
   - `flask run -h 0.0.0.0`
5. Run app in iOS simulator (Android currently not supported)
   * `pitchfork_app/ios/Runner.xcworkspace`
   * Note: if you want to run it on your real device you will need an active Apple developer account.
6. Enjoy good music reviews!

## Screenshots
<p float="left">
  <img src="https://user-images.githubusercontent.com/60407839/111528244-88e2bd00-8726-11eb-9293-cf8a37d7802f.png" width="200" height="400" />
  <img src="https://user-images.githubusercontent.com/60407839/111528692-145c4e00-8727-11eb-975e-ed21fa69804b.png" width="200" height="400" />
  <img src="https://user-images.githubusercontent.com/60407839/111528260-8f713480-8726-11eb-9774-e4b8b924e673.png" width="200" height="400" />
  <img src="https://user-images.githubusercontent.com/60407839/111528282-9304bb80-8726-11eb-9809-52bddba0901d.png" width="200" height="400" />
</p>


