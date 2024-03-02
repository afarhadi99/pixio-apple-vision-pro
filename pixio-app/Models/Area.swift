//
//  Area.swift
//  pixio-app
//
//  Created by Ross Cohen on 2/29/24.
//

import Foundation

enum Area : String, Identifiable, CaseIterable, Equatable
{
    // app areas we will use for navigation purposes
    case generate, draw
    var id: Self { self }
    var name: String { rawValue.capitalized }
    
    var title: String {
        switch self {
            case .generate:
                "Start generating by typing a prompt"
            case .draw:
                "Enter a prompt and start drawing"

        }
    }
}
