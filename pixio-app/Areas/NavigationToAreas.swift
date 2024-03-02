//
//  NavigationToAreas.swift
//  pixio-app
//
//  Created by Ross Cohen on 2/29/24.
//

import SwiftUI

struct NavigationToAreas: View {
    var body: some View {
        VStack {
            
            Image("pixiologo") // Use your image name here
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding(.bottom, 25)
                        
            HStack(spacing: 25) {
                ForEach(Area.allCases) { area in
                    NavigationLink {
                        
                        if area == Area.generate {
                            GenerateArea()
                        }
                        
                        else if area == Area.draw {
                            DrawArea()  
                        }
                        
                    } label: {
                        Label(area.name, systemImage: "chevron.right")
                            .monospaced()
                            .font(.title)
                    }
                    .controlSize(.extraLarge)
                }
            }
        }
    }
}

#Preview {
    NavigationToAreas()
        .environment(ViewModel())
    
}
