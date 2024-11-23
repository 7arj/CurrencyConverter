# Currency Converter App

  

A modern Flutter application that allows users to convert currencies with real-time exchange rates. The app is designed to provide a seamless and intuitive user experience, with features like currency selection, persistent preferences, and accurate conversion results.

  

## Setup Guide

  

 1. ### Prerequisites

	Ensure you have the following installed:
			
	  -  [Flutter SDK](https://flutter-ko.dev/get-started/install)
	  - Android Studio or Visual Studio Code (with Flutter extensions)

2. ### Clone the Repository

    git clone https://github.com/7arj/CurrencyConverter.git  
 

3. ### Install Dependencies
	Run the following command to install the required Flutter packages:
	

    flutter pub get
4. ### Configure the API key
	1. Copy the example configuration file:
		

         cp lib/utils/config.example.dart lib/utils/config.dart  
         

	2.  Open the `config.dart` file and replace `your_api_key_here` with your actual API key which you can get for free from https://www.exchangerate-api.com/
	
5. ### Run the app
	Start the  application using the following command:

	flutter run  

## Features

 - **Real-Time Currency Conversion**: Fetches up-to-date exchange rates from the [ExchangeRate-API](https://www.exchangerate-api.com/)
 - **Swap Currencies**: Quickly swap the base and target currencies with a single click.
 - **Persistent Preferences**: Uses `SharedPreferences` to remember your last selected currencies and entered amount.

## Demo

https://github.com/user-attachments/assets/db4bb2b8-e846-4c5c-bdf4-45f975bec7f9





