//
//  MessageHandlerDelegate.swift
//  IoTClient
//
//  Created by Vui Nguyen on 7/9/16.
//  Copyright © 2016 Sunfish Empire. All rights reserved.
//

import Foundation

protocol MessageHandlerDelegate {
    func updateToggleButton(LEDColor: String, LEDStatus: Int)
}
