//
//  ViewController.swift
//  IoTClient
//
//  Created by Vui Nguyen on 6/28/16.
//  Copyright © 2016 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MessageHandlerDelegate {
    
    var connectedToServer: Bool = false
    
    enum LEDColors: String {
        case Green, Red, Blue
    }
    
    enum LEDIds: Int {
        case Green = 1, Red, Blue
    }
    
    @IBOutlet weak var connectionButton: UIButton!
    
    @IBOutlet weak var connectionToServerLabel: UILabel!
    
    @IBOutlet weak var toggleLEDButton: UIButton!
    
    @IBOutlet weak var toggleRedLedButton: UIButton!
    
    @IBOutlet weak var toggleBlueLedButton: UIButton!
    
    // This is to toggle the GREEN LED. The button and the action were named back when
    // there was only 1 LED, the GREEN one
    @IBAction func toggleLED(sender: AnyObject) {
        let msg = buildMessage(LEDColors.Green.rawValue, LEDId: LEDIds.Green.rawValue)
       
        SocketIOManager.sharedInstance.socket.emit("toggle led", msg)
    }
    
    @IBAction func toggleRedLED(sender: AnyObject) {
        let msg = buildMessage(LEDColors.Red.rawValue, LEDId: LEDIds.Red.rawValue)
        
        SocketIOManager.sharedInstance.socket.emit("toggle led", msg)
    }
    
    @IBAction func toggleBlueLED(sender: AnyObject) {
        let msg = buildMessage(LEDColors.Blue.rawValue, LEDId: LEDIds.Blue.rawValue)
    
        SocketIOManager.sharedInstance.socket.emit("toggle led", msg)
    }
    
    @IBAction func handleConnectionToServer(sender: AnyObject) {
        // we want to connect to the server
        if (connectedToServer == false)
        {
            connectionButton.setTitle("Disconnect", forState: .Normal)
            connectionToServerLabel.text = "Connected to Server"
            connectedToServer = true
            
            SocketIOManager.sharedInstance.establishConnection()
            
            // make toggle buttons appear once we connect
            toggleLEDButton.hidden = false
            toggleRedLedButton.hidden = false
            toggleBlueLedButton.hidden = false
        }
        else    // we want to disconnect from the server
        {

            connectionButton.setTitle("Connect", forState: .Normal);
            connectionToServerLabel.text = "Not Connected to Server"
            connectedToServer = false
            
            SocketIOManager.sharedInstance.closeConnection()
            
            // hide toggle buttons once we disconnect
            toggleLEDButton.hidden = true
            toggleRedLedButton.hidden = true
            toggleBlueLedButton.hidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // This class (us) will handle the messages coming through the SocketIOManager
        SocketIOManager.sharedInstance.delegate = self
        
        // start off by hiding the toggle buttons because we're not connected
        // to the web server yet
        toggleLEDButton.hidden = true
        toggleRedLedButton.hidden = true
        toggleBlueLedButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildMessage(LEDColor: String, LEDId: Int) -> [String: AnyObject]
    {
        var msg = [String: AnyObject]()
        msg["userId"] = SocketIOManager.sharedInstance.userId
        msg["value"] = Int(0)
        msg["ledId"] = LEDId
        msg["ledColor"] = LEDColor
        return msg
    }

    func updateToggleButton(LEDColor: String, LEDStatus: Int) {
        //print(LEDColors.Green.rawValue, LEDColors.Red.rawValue, LEDColors.Blue.rawValue)
        print("updateToggleButton, LEDColor: \(LEDColor), LEDStatus: \(LEDStatus)")
        
        // if the LEDStatus is 1, change button background color to a solid color, else
        // make the button background color clear
            switch LEDColor {
                case  LEDColors.Green.rawValue:
                    toggleLEDButton.backgroundColor =
                        (LEDStatus == 1) ? UIColor.greenColor() : UIColor.clearColor()
                    break;
            
                case  LEDColors.Red.rawValue:
                    toggleRedLedButton.backgroundColor =
                        (LEDStatus == 1) ? UIColor.redColor() : UIColor.clearColor()
                    break;
            
                case  LEDColors.Blue.rawValue:
                     toggleBlueLedButton.backgroundColor =
                        (LEDStatus == 1) ? UIColor.cyanColor() : UIColor.clearColor()
                     break;
            
                default: break
            }
    }
}

