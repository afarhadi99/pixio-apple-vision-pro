//
//  pixio_appApp.swift
//  pixio-app
//
//  Created by Ross Cohen on 2/28/24.
//

import SwiftUI

@main
struct pixio_appApp: App {
    
    @State private var model = ViewModel()
    
    var body: some Scene {
        WindowGroup("Main Areas", id: "Areas") {
            Areas()
                .environment(model)
        }
        
        WindowGroup(id: "GenerateImageArea") {
            GenerateImageArea()
                .environment(model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)
        
        ImmersiveSpace(id: "FullGenerateArea") {
             FullGenerateArea()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
