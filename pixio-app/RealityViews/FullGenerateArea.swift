//
//  FullGenerateArea.swift
//  pixio-app
//
//  Created by Ross Cohen on 2/29/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FullGenerateArea: View {
    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "Immersive", in:
                realityKitContentBundle) else {
                    fatalError("Unable to load")
                }
            
            content.add(entity)
            }
        }
    }

#Preview {
    FullGenerateArea()
        .environment(ViewModel())
}
