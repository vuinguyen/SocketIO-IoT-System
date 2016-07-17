//
//  SocketIOManager.swift
//  IoTClient
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//
//  Modified by Vui Nguyen on 6/29/16
//  Sunfish Empire LLC
//
//  Note: This file originally came from this github and tutorial:
//  http://www.appcoda.com/socket-io-chat-app/
//  https://github.com/appcoda/SocketIOChat
//  It was written for an iOS Chat Application using Socket.io
//  I have since modified and repurposed it for my own needs, which is to control
//  LED Lights on an Arduino/Intel Edison board
//  Much thanks to Gabrial Theodoropoulos for giving me a head start on my program! :)

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    // this is the address for my Intel Edison board, your address may be different!
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://10.0.0.15:3000")!)
    
    // this is the id of the current mobile client, which is us
    var userId = ""
    
    // all users connected to the web server
    var connectedUsers: [String] = []
    
    // another class will handle the toggle messages received by SocketIOManager
    var delegate: MessageHandlerDelegate?
    
    override init() {
        super.init()
    }
    
    func getUserId() -> String {
        return userId
    }
    
    func establishConnection() {
        socket.connect()
        listenForOtherMessages()
    }
    
    
    func closeConnection() {
        // before we disconnect, we need to send our user id to the server
        socket.emit("user disconnect", userId)
        
        // listen for confirmation from the server and then we can disconnect
        socket.on("user disconnect") { (dataArray, socketAck) -> Void in
            let serverUserId =  dataArray[0] as! String
            if (self.userId == serverUserId)
            {
                print("BEFORE: userId is \(self.userId)")
                self.userId = ""
                print("AFTER: userId is \(self.userId)")
                self.socket.disconnect()
                
                // this was an awesome hack found from here:
                /* http://stackoverflow.com/questions/27878798/remove-specific-array-element-equal-to-string-swift
 */
                // remove our own user id from connectedusers
                self.connectedUsers = self.connectedUsers.filter{$0 != serverUserId}
                print ("\(self.connectedUsers)")
            } // end if
        }   // end socket.on
    }   // end closeConnection
    
    
    private func listenForOtherMessages() {
        // listen for a "user connect" message to store the user id from the server
        // as soon as we connect with the server
        socket.on("user connect") { (dataArray, socketAck) -> Void in
            if (self.userId == "") {
                self.userId =  dataArray[0] as! String
                print("userId is \(self.userId)")
            }
        }
        
        socket.on("connected users") { (dataArray, socketAck) -> Void in
            self.connectedUsers = []
            
            // print("\(dataArray)\n")
            print("\(dataArray[0])")
            
            let inConnectedUsers = dataArray[0] as! NSArray
            
            for id in inConnectedUsers {
                self.connectedUsers.append(id as! String)
            }
            print("connected users are:\(self.connectedUsers)")
        }
        
    
        socket.on("toggle led") { (dataArray, socketAck) -> Void in
            print("toggle led")
            print("\(dataArray)\n")
            print("\(dataArray[0])")
            
            let dataDictionary = dataArray[0] as! NSDictionary
            print("\(dataDictionary["userId"])")
            print("\(dataDictionary["value"])")
            print("\(dataDictionary["ledId"])")
            print("\(dataDictionary["ledColor"])")
            
            self.delegate?.updateToggleButton(dataDictionary["ledColor"] as! String, LEDStatus: dataDictionary["value"] as! Int)
        }
        
        /*
         // Comment out as we don't need chat capability right now
        socket.on("chat message") { (dataArray, socketAck) -> Void in
            print("chat message")
            //print("\(dataArray)\n")
            print("\(dataArray[0])")
            
            let dataDictionary = dataArray[0] as! NSDictionary
            print("\(dataDictionary["userId"])")
            print("\(dataDictionary["value"])")
        }
       */
    }
}
