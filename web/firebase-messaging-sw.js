/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

// todo Copy/paste firebaseConfig from Firebase Console
const firebaseConfig = {
   apiKey: "AIzaSyBzyGYtpNvTkSStT47EgpggiV79BicF5eU",
     authDomain: "flutter-message-task.firebaseapp.com",
     projectId: "flutter-message-task",
     storageBucket: "flutter-message-task.appspot.com",
     messagingSenderId: "276083202125",
     appId: "1:276083202125:web:211b52adc60bf3ce1fe404"
 };

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// todo Set up background message handler
messaging.onBackgroundMessage((message) => {
 console.log("onBackgroundMessage", message);
});