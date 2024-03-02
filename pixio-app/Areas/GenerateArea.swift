//
//  GenerateArea.swift
//  pixio-app
//
//  Created by Ross Cohen on 2/29/24.
//

import SwiftUI
import FalClient

struct GenerateArea: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @State private var inputText: String = ""
    @State private var imageUrl: String? = nil
    @State private var isLoading: Bool = false // State variable for input field
    
    private let fal = FalClient.withCredentials(.keyPair("d61111cf-254a-4561-8fe4-ce62c3f2472d:0d22a099b8f1da57089d65db9da5ec71"))
    
    var body: some View {
        @Bindable var model = model
            
            VStack {
                Image("pixiologo") // Use your image name here
                    .frame(width: 100)
                HStack {
                    TextField("Enter text", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    
                    Button("Generate") {
                        Task {
                            await generateImage(prompt: inputText)
                        }
                    }
                    .padding()
                }
                
                if isLoading {
                    ProgressView()
                } else if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                    ZStack {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 500, height: 500)
                        .padding()

                        

                    }
                }
            }
    }
    func generateImage(prompt: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await fal.subscribe(
                to: "fal-ai/stable-cascade",
                input: [
                    "prompt": prompt,
                    "negative_prompt": "cartoon, illustration, animation. face. male, female",
                    "first_stage_steps": 20,
                    "second_stage_steps": 10,
                    "guidance_scale": 4,
                    "image_size": "square_hd",
                    "num_images": 1,
                    "loras": [],
                    "enable_safety_checker": true
                ].asPayload(),
                pollInterval: .seconds(1),
                timeout: .seconds(30),
                includeLogs: true
            ) { update in
                // Handle real-time updates if necessary
                print(update)
            }
            
            // Assuming the result contains an "images" array with URLs
            if let imagesPayload = result["images"]?.arrayValue {
                if let firstImagePayload = imagesPayload.first, let imageUrl = firstImagePayload["url"]?.stringValue {
                    DispatchQueue.main.async {
                        self.imageUrl = imageUrl
                    }
                }
            }
        } catch {
            print("Failed to generate image: \(error)")
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    func asPayload() -> Payload {
        .dict(self.reduce(into: [String: Payload]()) { result, pair in
            result[pair.key] = Payload(pair.value)
        })
    }
}

extension Payload {
    init(_ value: Any) {
        switch value {
        case let value as String:
            self = .string(value)
        case let value as Int:
            self = .int(value)
        case let value as Double:
            self = .double(value)
        case let value as Bool:
            self = .bool(value)
        case let value as Data:
            self = .data(value)
        case let value as Date:
            self = .date(value)
        case let value as [Any]:
            self = .array(value.map(Payload.init))
        case let value as [String: Any]:
            self = .dict(value.reduce(into: [String: Payload]()) { result, pair in
                result[pair.key] = Payload(pair.value)
            })
        default:
            self = .nilValue
        }
    }
    
    var arrayValue: [Payload]? {
        if case let .array(value) = self {
            return value
        }
        return nil
    }
    
    var stringValue: String? {
        if case let .string(value) = self {
            return value
        }
        return nil
    }
    
    subscript(key: String) -> Payload? {
        if case let .dict(dict) = self {
            return dict[key]
        }
        return nil
    }
}


#Preview {
    GenerateArea()
        .environment(ViewModel())
}
