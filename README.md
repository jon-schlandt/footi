# Footi

Footi is an iOS app that provides standings, fixtures, and stat leaders for several top-flight soccer leagues. Stay updated with the latest scores, upcoming matches, and key player statistics with Footi!

<p align="center">
  <img alt="launch screen" src="https://github.com/jon-schlandt/footi/assets/75702270/7583addb-058e-480f-a0b1-eedfc1bedb96" width="20%">
  &nbsp; &nbsp; &nbsp;
  <img alt="standings tab" src="https://github.com/jon-schlandt/footi/assets/75702270/2e8a3d86-b408-4c9f-889b-056234a7f998" width="20%">
  &nbsp; &nbsp; &nbsp;
  <img alt="fixtures tab" src="https://github.com/jon-schlandt/footi/assets/75702270/09e23ff5-10fc-44f4-968a-66b5a2f9e1ba" width="20%">
  &nbsp; &nbsp; &nbsp;
  <img alt="fixtures tab" src="https://github.com/jon-schlandt/footi/assets/75702270/1c55b673-93ff-4174-8e5e-2827cd16b1f0" width="20%">
  &nbsp; &nbsp; &nbsp;
</p>

## Features

- View live standings for top-flight soccer leagues.
- Access live fixture information to keep track of upcoming matches.
- Check out the statistical leaders in various categories such as goals, assists, and more.
- Set the default league that displays on start-up.

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone or download the repository.
2. Open the project in Xcode.
3. Build and run the app on the desired simulator or device.

## Usage

1. Launch the app on your iOS device or simulator.<br>
2. Open the menu via the &nbsp;<img width="20px" alt="menu icon" src="https://github.com/jon-schlandt/footi/assets/75702270/7df117f6-4d12-48fa-9fde-be2bfe1bdf86">&nbsp; icon and choose a league from the available options.<br>
3. Navigate through the different tabs to access standings, fixtures, and stat leaders.<br>
4. Access the Settings view via the &nbsp;<img width="20px" alt="settings icon" src="https://github.com/jon-schlandt/footi/assets/75702270/252d024b-b181-470b-9830-9599cad276f0">&nbsp; icon from the menu to update the default league.<br>
5. Enjoy staying updated with the latest soccer data!<br>

## API Usage

If running the app in DEBUG mode, static data is retrieved using local JSON files. Footi relies on the following API to fetch soccer league data in RELEASE mode:

- API Name: API-Football
- Base URL: api-football-v1.p.rapidapi.com
- Documentation: [API-Footbal - Documentation](https://www.api-football.com/documentation-v3)

To use the app, you'll need to obtain an API key from API-Football and place it in an environmental variable with name: APIFOOTBALL_KEY. The base URL should be added
as an environmental variable with name: APIFOOTBALL_HOST.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with descriptive commit messages.
4. Push your branch to your fork.
5. Create a pull request, explaining the changes you made.

## Contact

If you have any questions or inquiries, please contact me, the developer, at schlanjo@gmail.com.
