# SocketIO-IoT-System

This project is an IoT system that uses a web client and iOS mobile client to control LED lights on an Intel Edison board. Communicates with the board through the local websocket server using the Socket.io libraries for web and iOS.

The websocket server and web client application are in the WebsocketServer folder. The iOS mobile client that works with this system is in the iOSClient folder.

The original system that this project was based on, is a web client that controls an onboard LED light on an Intel Edison board via a local websocket server. I've since modified it to control 3 LED lights via the web client, and developed the iOS mobile client to control the lights as well.

The iOS mobile client uses the Socket.io library for iOS. I got my start on this mobile app through this project:
https://github.com/appcoda/SocketIOChat

The web client and websocket server uses the Socket.io library for web. I got my start on this part of the system through this project:
https://software.intel.com/en-us/creating-an-application-to-communicate-using-web-sockets

A video of my final, completed system is here:
http://bit.ly/ControlLEDsWithApp

Blog posts about my system are here:
https://sunfishempire.wordpress.com/copyofcontrollingledlights-formaziel/

https://sunfishempire.wordpress.com/copyofcontrollingledlightswithwebsite-formaziel/

https://sunfishempire.wordpress.com/copy-of-controlling-led-lights-with-mobile-app-for-maziel/

===================================
Also, in spite of what Github says, only the iOS mobile app is in Swift. But the webserver and web client were written in JavaScript, specifically Node.js, Express.js, and of course, Socket.io . And yes, there were some challenges with mixing JavaScript and Swift within the same system. Ask me about it when you interview me for a job. :)



