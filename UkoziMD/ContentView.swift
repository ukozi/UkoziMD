//
//  ContentView.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 10/29/22.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var responseDatum = newResponse
    
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
            HStack {
                Picker(selection: .constant(1), label: Text("Recording Source")) {
                    Text("Analog In").tag(1)
                    Text("Optical In 1").tag(2)
                    Text("Optical In 2").tag(3)
                } .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                Picker(selection: .constant(4), label: Text("Play Mode")) {
                    Text("Shuffle").tag(1)
                    Text("Repeat Single").tag(2)
                    Text("Repeat All").tag(3)
                    Text("Play Through").tag(4)
                } .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                
            }
            HStack(alignment: .center) {
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
