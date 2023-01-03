//
//  transforms.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 11/4/22.
//

import Foundation
var trackCounter: Int = 0



extension String {
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}


class responseDecoder: ObservableObject {
    
    var decodedTitle: String = ""
    var decodedTrack: String = ""
    var responseData: [UInt8] = []
    @Published var thisDisc: Disc = Disc(Title: "", tracks: [])
    @Published var thisTrack: Track = Track(id: 0, title: "")
    @Published var nowPlaying: String = ""
    @Published var playModesState: Int = 0
    //0 = Straight Play thru; 1 = Shuffle; 2 = Program
    @Published var inputModeState: Int = 0
    // 0 = Analog; 1 = Optical1; 2 = Optical2
    @Published var repeatModeState: Int = 0
    // 0 = No Repeat; 1 = Repeat All; 2 = Repeat 1
    @Published var discModeState: Int = 0
    // 0 = No Disc; 1 = Stopped; 2 = Playing; 3 = Queued for Recording
    
    
    func mdInterpret() {
        
        switch responseData {
        case [144, 7, 5, 71, 2, 2, 255]:
            print("MiniDisc is stopped. Ready.")
            getTitle()
            getTotalTracks()
            nowPlaying = ""
            
        case [144, 7, 5, 71, 64, 3, 255]:
            print("No MiniDisc Loaded!")
            nowPlaying = "No Disc"
            thisDisc.Title = ""
            
        case [144, 7, 5, 71, 2, 64, 255]:
            print("Attempting to eject a MiniDisc...")
            
        case [144, 12, 5, 71, 32, 32, 0, 128, 1, 1, 0, 255]:
            print("Loading a MiniDisc...")
            
        case [144, 7, 5, 71, 32, 130, 255]:
            print("A MiniDisc has been inserted...")
            
            
        case [144, 7, 5, 71, 32, 128, 255]:
            print("A MiniDisc was ejected.")
            thisDisc.tracks = []
            nowPlaying = "No Disc"
            thisDisc.Title = ""
            trackCounter = 0
            
            
        case [144, 7, 5, 71, 2, 1, 255]:
            print(decodedTitle + " is playing.")
            
        case [144, 7, 5, 71, 32, 132, 255]:
            print("30 seconds to next track...")
            
            
        default: mdGranularInterpret()
            
        }
    }
    
    func mdGranularInterpret() {
        
        switch responseData[5] {
            
        case 88:
            if responseData[22] == 0 {
                let firstLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTitle = firstLine.description
                thisDisc.Title = decodedTitle
            } else {
                let firstLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTitle = firstLine.description
            }
            
            
        case 89:
            if responseData[22] == 0{
                let additionalLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTitle = decodedTitle + additionalLine
                thisDisc.Title = decodedTitle
            } else {
                let additionalLine:String = String(bytes: responseData[7...((responseData.endIndex)-2)], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTitle = decodedTitle + additionalLine
            }
            
            
            
        case 80:
            if responseData[4] == 32 {
                let nowPlaying:Int = Int(responseData[7])
                currentTrackNumber = responseData[7]
                print("Now playing track #" + String(nowPlaying))
                getPlayingTrackTitle()
            } else {
                print("New uninterpreted response from deck!"); print(Array(responseData))
            }
            
        case 90:
            
            thisTrack.id = Int(responseData[6])
            
            if responseData[22] == 0 {
                let firstTrackTitleLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTrack = firstTrackTitleLine
                if thisDisc.tracks.contains(where: {$0.id == thisTrack.id}){
                    let currentTrackTitle = thisDisc.tracks[thisTrack.id-1]
                    nowPlaying = currentTrackTitle.title
                    print(nowPlaying)
                    
                } else {
                    thisTrack.title = decodedTrack
                    thisDisc.tracks.insert(thisTrack, at: trackCounter)
                    print(thisDisc)
                    trackCounter = trackCounter + 1 }
            } else {
                let firstTrackTitleLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTrack = firstTrackTitleLine
            }
            
        case 91:
            
            if responseData[22] == 0 {
                let nextTrackTitleLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTrack = decodedTrack + nextTrackTitleLine
                if thisDisc.tracks.contains(where: {$0.id == thisTrack.id}){
                    let currentTrackTitle = thisDisc.tracks[thisTrack.id-1]
                    nowPlaying = currentTrackTitle.title
                    print(nowPlaying)
                } else {
                    thisTrack.title = decodedTrack
                    thisDisc.tracks.insert(thisTrack, at: trackCounter)
                    print(thisDisc)
                    trackCounter = trackCounter + 1 }
            } else {
                let nextTrackTitleLine:String = String(bytes: responseData[7...22], encoding: .ascii)!.removeCharacters(from: "\0")
                decodedTrack = decodedTrack + nextTrackTitleLine
            }
            
        case 96:
            let totalTracks:Int = Int(responseData[8])
            let strTotalTracks:String = String(responseData[8])
            getTrackTitles(totalTracks: totalTracks, responseData: responseData[8])
            print(decodedTitle + " has " + strTotalTracks + " tracks.")
            
        case 32:
            
            switch responseData[6] { //From 0 - This byte is the disc state
            case 0:
                discModeState = 1
                print("MiniDisc Present. Stopped.")
                
            case 1:
                discModeState = 2
                print("MiniDisc Present. Playing.")
                
            case 5:
                discModeState = 3
                print("MiniDisc Present. Queued for Recording.")
                
            case 35:
                discModeState = 0
                print("No MiniDisc Present.")
                
            default: print("New uninterpreted response from deck!"); print(Array(responseData))
            }
            
            switch responseData[7] { //From 0 - This byte is the playback mode state
            case 160:
                repeatModeState = 0
                playModesState = 0
                print("No Repeat. No Shuffle.")
            case 161:
                repeatModeState = 0
                playModesState = 1
                print("No Repeat. Shuffle.")
            case 162:
                repeatModeState = 0
                playModesState = 2
                print("No Repeat. Program.")
            case 168:
                repeatModeState = 1
                playModesState = 0
                print("Repeat All. No Shuffle.")
            case 169:
                repeatModeState = 1
                playModesState = 1
                print("Repeat All. Shuffle.")
            case 170:
                repeatModeState = 1
                playModesState = 2
                print("Repeat All. Program.")
            case 176:
                repeatModeState = 2
                playModesState = 0
                print("Repeat 1. No Shuffle.")
            case 177:
                repeatModeState = 2
                playModesState = 1
                print("Repeat 1. Shuffle.")
            case 178:
                repeatModeState = 2
                playModesState = 2
                print("Repeat 1. Program.")
                
            default: print("New uninterpreted response from deck!"); print(Array(responseData))
            }
            
            switch responseData[8] { //From 0 - This Byte is the Input Source state
            case 1:
                inputModeState = 0
                print("Input Method is Analog")
            case 3:
                inputModeState = 1
                print("Input Method is Optical 1")
            case 4:
                inputModeState = 2
                print("Input Method is Optical 2")
            default: print("New uninterpreted response from deck!"); print(Array(responseData))
            }
            
            
            
            
        default: print("New uninterpreted response from deck!"); print(Array(responseData))
            
            
            
        }
        
    }
    
    func getTrackTitles(totalTracks:Int, responseData:UInt8) {
        if totalTracks > 0 {
            var track = 1
            print("Asking MiniDisc deck for track titles...")
            while(track <= totalTracks) {
                sleep(1)
                let trackHex = UInt8(track)
                let cmd_list:[UInt8] = [0x81,0x08,0x07,0xb0,0x5a,trackHex,0x00,0xff]
                let cmd_buffer = Data(cmd_list)
                do {
                    try serialPort.writeData(cmd_buffer)
                    
                    track = track + 1
                } catch {
                    print("Error: \(error)")
                }
                
                
            }
        }
        
        
    }
}

var newResponse = responseDecoder()
var listen = true

func backgroundRead() {
    while listen==true {
        do {
            let response = try serialPort.readByte()
            let responseBinary:UInt8 = response
            DispatchQueue.main.async {
                if responseBinary == 255 {
                    newResponse.responseData.append(responseBinary)
                    newResponse.self.mdInterpret()
                    newResponse.responseData = []
                } else if newResponse.responseData == [0] {
                    newResponse.responseData = []
                } else {
                    newResponse.responseData.append(responseBinary)
                }
            }
            
        }
        catch {
            print("Error: \(error)")
            listen = false
        }
    }
}
