//
//  Comms.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 10/31/22.
//

import Foundation
import SwiftSerial

//var connection:Int = 0
let serialPort: SerialPort = SerialPort(path: "/dev/cu.usbserial-21230")
var currentTrackNumber:UInt8 = 0


extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

func connect() {
    do {
        try serialPort.openPort()
        serialPort.setSettings(receiveRate: .baud9600, transmitRate: .baud9600, minimumBytesToRead: 0)
        print("Port Opened.")
    } catch PortError.failedToOpen {
        print("Serial Port Failed To Open")
        newResponse.nowPlaying = "No MiniDisc deck is connected."
        
    } catch {
        print("Error: \(error)")
    }
}

func stop() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x01,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func play() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x00,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
    trackCounter = 0
}

func pause() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x02,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func unpause() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x03,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func eject() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x04,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func stage() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x07,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func next() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x08,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}

func previous() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x09,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}
func getTitle() {
    let cmd_list:[UInt8] = [0x81,0x08,0x07,0xb0,0x58,0x01,0x00,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)

    } catch {
        print("Error: \(error)")
    }
}
func dac() {
    let cmd_list:[UInt8] = [0x81,0x06,0x07,0xb0,0x04,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)
        
    } catch {
        print("Error: \(error)")
    }
    let cmd_next:[UInt8] = [0x81,0x06,0x07,0xb0,0x07,0xff]
    let next_buffer = Data(cmd_next)
    do {
        try serialPort.writeData(next_buffer)
        
    } catch {
        print("Error: \(error)")
    }
}
func getPlayingTrackTitle() {
    let cmd_list:[UInt8] = [0x81,0x08,0x07,0xb0,0x5a,currentTrackNumber,0x00,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)

    } catch {
        print("Error: \(error)")
    }
}
func getTotalTracks() {
    let cmd_list:[UInt8] = [0x81,0x07,0x07,0xb0,0x44,0x01,0xff]
    let cmd_buffer = Data(cmd_list)
    do {
        try serialPort.writeData(cmd_buffer)

    } catch {
        print("Error: \(error)")
    }
}



