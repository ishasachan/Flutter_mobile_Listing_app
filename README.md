# Flutter Mobile Listing with Firebase Messaging

This project is developed as part of an internship task. It is a mobile application built with Flutter that provides information about various mobile devices. The main objective of the project was to create a user-friendly UI, fetch data from an API, and display it on the screen. Additionally, the app includes a search functionality to find specific mobile devices and offers various filters based on the API data. Furthermore, Firebase Cloud Messaging integration has been implemented to enable push notifications.

## Features

- *Product Listing:* The app displays a list of mobile devices fetched from the API with support for infinite scrolling, ensuring a smooth browsing experience.

- *Filter Options:* Users can use various filters to narrow down their search for mobile phones. Filters such as brand, RAM, storage, and condition are populated with data from the API.

- *Search Functionality:* The app allows users to search for specific mobile devices. The search results are fetched from the API, showing relevant make and model information.

- *Notifications:* Firebase Cloud Messaging is integrated into the app to deliver push notifications. Users will receive timely notifications about new deals, offers, or any other important updates.

## Installation

To get started with the app, follow these steps:

1. Clone the repository to your local machine:

bash
git clone https://github.com/ishasachan/flutter_internship


2. Change into the project directory:

bash
cd flutter_internship


3. Install the required dependencies:

bash
flutter pub get


4. Run the app on your preferred device:

bash
flutter run


## Usage

After installing and running the app, you can utilize the following features:

- *Product Listing:* On the home screen, you will find a list of mobile devices. You can scroll through the list to explore various options.

- *Filter Options:* Use the filters at the top to refine your search. Select your preferred brand, RAM, storage, and condition options, and the list will update accordingly.

- *Search Functionality:* To find specific mobile devices, simply use the search bar. The search results will display relevant make and model information based on the API data.

- *Notifications:* Keep an eye on the notification section to receive updates about new deals, offers, or important announcements. The app will deliver timely notifications using Firebase Cloud Messaging.

## Technologies Used

This project is built using the following technologies and libraries:

- Flutter: A popular open-source UI software development toolkit created by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.
- Dart: The programming language used for building Flutter apps.
- Firebase Cloud Messaging: A cross-platform messaging solution that allows you to reliably deliver messages at no cost.


## Memory Management 
Since Memory Management is one of the most crucial part of any application so I have taken special regarding it. In throughout the app all the memory has been properly disposed using the dispose method which will prevent all the necessary memory leaks and also using the cached_network_image plugin that helps to cache the image and help in increasing performance of the application. I have tried to divide the application into different folders in order to modularise the code and also created models for products and filter. Further there are lots of more scope regarding the memory management but since we have to do mostly the UI part, data fetching and Flutter Firebase Cloud Messaging service so this I feel is right for now.

## Contributing

Contributions to this project are welcome! If you encounter any issues or have suggestions for improvements, please feel free to open a pull request or create an issue in the repository.

To contribute, follow these guidelines:

1. Fork the repository to your GitHub account.
2. Create a new branch from the main branch with a descriptive name for your changes.
3. Make your changes and test them thoroughly.
4. Create a pull request against the main branch of this repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
