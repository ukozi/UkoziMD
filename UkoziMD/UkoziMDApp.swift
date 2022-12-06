//
//  UkoziMDApp.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 10/29/22.
//

import SwiftUI

@main
struct UkoziMDApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            CommandGroup(replacing: .newItem, addition: { })
            CommandGroup(replacing: .appInfo) {
                         Button("About UkoziMD") {
                             NSApplication.shared.orderFrontStandardAboutPanel(
                                 options: [
                                     NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                         string: "Created with ❤️ by Lucas in Tennessee",
                                         attributes: [
                                             NSAttributedString.Key.font: NSFont.boldSystemFont(
                                                 ofSize: NSFont.smallSystemFontSize)
                                         ]
                                     ),
//                                     NSApplication.AboutPanelOptionKey(
//                                         rawValue: "Copyright"
//                                     ): "© 2022 Lucas J. Chumley"
                                 ]
                             )
                         }
                     }
        } .windowToolbarStyle(UnifiedWindowToolbarStyle())
       
    }
} 
