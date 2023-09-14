
//
//  DemoKeyboardView.swift
//  KeyboardTextInput
//
//  Created by Daniel Saidi on 2023-03-10.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

/**
 This view adds a `SystemKeyboard` and two text input fields
 to a `VStack`.

 The text fields use a custom `focused` modifier that can be
 used to also automatically show a "done" button when a text
 field receives input. As you can see, the text input fields
 use separate text and focus bindings.
 */
struct DemoKeyboardView: View {

    @State
    private var text1 = ""

    @State
    private var text2 = ""

    @FocusState
    private var isFocused1: Bool

    @FocusState
    private var isFocused2: Bool

    unowned var controller: KeyboardInputViewController
    
    @State private var isContentVisible = false
    @State private var selectedLength = "Short"
    @State private var prevText = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: printHello) {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.system(size: 30))
                }
                .padding(.horizontal) // Apply padding only to the horizontal edges
                .background(Color.white)
                .foregroundColor(.blue)
                .clipShape(Circle())
                
                Spacer()
                
                if !prevText.isEmpty {
                    Button(action: undo) {
                        Image(systemName: "arrow.uturn.backward") // Use a gear icon instead of text
                    }
                    .padding()
                    .clipShape(Circle())
                }
                
                Button(action: {
                    isContentVisible.toggle()
                }) {
                    Image(systemName: "gearshape") // Use a gear icon instead of text
                }
                .padding()
                .clipShape(Circle())
                
                
                }
                if isContentVisible {
                    HStack {
                        Text("Length:")
                            .font(.headline)
                            .padding(.leading, 10)
                        
                        Button(action: {
                            selectedLength = "Short"
                        }) {
                            Text("Short")
                        }
                        .padding()
                        .background(selectedLength == "Short" ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button(action: {
                            selectedLength = "Medium"
                        }) {
                            Text("Medium")
                        }
                        .padding()
                        .background(selectedLength == "Medium" ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button(action: {
                            selectedLength = "Long"
                        }) {
                            Text("Long")
                        }
                        .padding()
                        .background(selectedLength == "Long" ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 10)
            }

            SystemKeyboard(
                controller: controller,
                autocompleteToolbar: .none
            )
        }.buttonStyle(.plain)
    }
    
    private func printHello() {
        var fullText = ""
        
        var textBeingComposed = controller.keyboardContext.textDocumentProxy.documentContextBeforeInput ?? ""
        var textBeingComposed2 = controller.keyboardContext.textDocumentProxy.documentContextAfterInput ?? ""
        var textBeingComposed3 = controller.keyboardContext.textDocumentProxy.selectedText ?? ""
        fullText = "\(textBeingComposed)\(textBeingComposed3)\(textBeingComposed2)"
//        let textBeingComposed = controller.keyboardContext.textDocumentProxy.documentContextBeforeInput ?? ""
//        let textLength = textBeingComposed.count
//        print("Text being composed: \(textBeingComposed)")
        print("------------------")
        print(fullText)
        
//        // Define the URL for the request
//        guard let url = URL(string: "https://proofreadgpt-stage-4f9d6ac43559.herokuapp.com/proofread") else {
//            print("Invalid URL")
//            return
//        }
//
//        // Create the URLRequest object
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Set the request body
//        let requestBody = ["text": textBeingComposed]
//        request.httpBody = try? JSONEncoder().encode(requestBody)
//        print("HEY2")
//
//        // Delete the existing text
//        for _ in 0..<textLength {
//            controller.keyboardContext.textDocumentProxy.deleteBackward()
//        }
//
//        // Make the network request
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            print("HEY3")
//            // Handle the response here
//            if let error = error {
//                print("Error: \(error)")
//                controller.keyboardContext.textDocumentProxy.insertText(textBeingComposed)
//            } else if let data = data {
//                print("HEY4")
//                print(data)
//                let decoder = JSONDecoder()
//                print(String(data: data, encoding: .utf8) ?? "Invalid data")
//
//                let jsonString = (String(data: data, encoding: .utf8) ?? "Invalid data")
//                if let jsonData = jsonString.data(using: .utf8) {
//                    do {
//                           if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
//                               if let text = json["text"] as? String {
//                                   print(text) // prints: "Hello, world!"
//
//                                   // Insert new text
//                                   prevText = textBeingComposed
//                                   controller.keyboardContext.textDocumentProxy.insertText(text)
//                               }
//                           }
//                       } catch {
//                           controller.keyboardContext.textDocumentProxy.insertText(textBeingComposed)
//                           print("Error converting JSON string to dictionary: \(error)")
//                       }
//                }
//
//
//            }
//        }.resume()
    }

    
    private func undo() {
        let textBeingComposed = controller.keyboardContext.textDocumentProxy.documentContextBeforeInput ?? ""
        
        // Delete the existing text
        for _ in 0..<textBeingComposed.count {
            controller.keyboardContext.textDocumentProxy.deleteBackward()
        }

        // Insert new text
        controller.keyboardContext.textDocumentProxy.insertText(prevText)
        prevText = ""
    }
}

