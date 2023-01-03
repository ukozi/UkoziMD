//
//  ContentView.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 10/29/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var responseDatum = newResponse
    @State var failedConnect = false
    @State var playMode: Int = 4
    @State var recordingSource: Int = 1
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                
                VStack(alignment:.leading){
                    
                    Text(responseDatum.nowPlaying)
                        .font(Font.custom("5by7", size: 24))
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 0))
                    
                    Text(responseDatum.thisDisc.Title)
                        .font(Font.custom("5by7", size: 18))
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 5, trailing: 0))
                }
                
            }
            
            .toolbar(id: "Main") {
                
                ToolbarItem(id: "Record") {
                    Button(action: {dac()}){
                        Label("Record", systemImage: "record.circle")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                        
                        
                    }
                    
                }
                ToolbarItem(id: "Previous") {
                    Button(action: {previous()}){
                        Label("Previous", systemImage: "backward.end.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.green)
                        
                    }
                }
                ToolbarItem(id: "Play") {
                    Button(action: {
                        play()
                        
                    }){
                        Label("Play", systemImage: "play.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.green)
                        
                    }
                }
                ToolbarItem(id: "Next") {
                    Button(action: {next()}){
                        Label("Next", systemImage: "forward.end.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.green)
                        
                    }
                }
                ToolbarItem(id: "Pause") {
                    Button(action: {pause()}){
                        Label("Pause", systemImage: "pause.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.yellow)
                        
                    }
                }
                ToolbarItem(id: "Stop") {
                    Button(action: {
                        stop()
                        
                    }){
                        Label("Stop", systemImage: "stop.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.red)
                        
                    }
                }
                ToolbarItem(id: "Eject") {
                    Button(action: {eject()}){
                        Label("Eject", systemImage: "eject.fill")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.gray)
                        
                    }
                }
                ToolbarItem(id: "DAC"){
                    Button(action: {dac()}){
                        Label("DAC Mode", systemImage: "hifispeaker")
                        // .labelStyle(.iconOnly)
                            .foregroundColor(.blue)
                    }
                }
                
            }
            
            
            
            TabView {
                List(responseDatum.thisDisc.tracks) { track in
                    HStack {
                        Text(String(track.id))
                        Text(track.title)
                    }
                }
                .listStyle(.bordered(alternatesRowBackgrounds: true))
                
                .tabItem{
                    Text("Tracks")
                }
                
            }
            
            HStack {
                Spacer()
                if responseDatum.playModesState == 1{
                    Label("Shuffle", systemImage: "shuffle.circle.fill")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else {
                    Label("Shuffle", systemImage: "shuffle.circle")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly)
                }
                if responseDatum.repeatModeState == 1 {
                    Label("Repeat", systemImage: "repeat.circle.fill")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else if responseDatum.repeatModeState == 2 {
                    Label("Repeat", systemImage: "repeat.1.circle.fill")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else {
                    Label("Repeat", systemImage: "repeat.circle")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly)
                }
                if responseDatum.inputModeState == 0 {
                    Label("Analog", systemImage: "cable.connector.horizontal")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else {
                    Label("Analog", systemImage: "cable.connector.horizontal")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly)
                }
                if responseDatum.inputModeState == 1 {
                    Label("Optical 1", systemImage: "light.beacon.min")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else {
                    Label("Optical 1", systemImage: "light.beacon.min")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 0))
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly)
                }
                if responseDatum.inputModeState == 2{
                    Label("Optical 2", systemImage: "light.beacon.min")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 10))
                        .foregroundColor(.accentColor)
                        .labelStyle(.iconOnly)
                } else {
                    Label("Optical 2", systemImage: "light.beacon.min")
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 10))
                        .foregroundColor(.secondary)
                        .labelStyle(.iconOnly)
                }
            }
            
            
            
            
            .navigationTitle("UkoziMD")
            .onAppear(perform:{
                connect()
                DispatchQueue.global(qos: .userInitiated).async {
                    backgroundRead()
                }
                sleep(5)
                getTitle()
            })
            
            
            
            
            
            
        }
        
    }
    
}
