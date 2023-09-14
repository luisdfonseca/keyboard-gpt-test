////
////  KeyboardViewController.swift
////  KeyboardTextInput
////
////  Created by Daniel Saidi on 2023-03-10.
////  Copyright © 2023 Daniel Saidi. All rights reserved.
////
//
//import KeyboardKit
//import SwiftUI
//
///**
// This keyboard demonstrates how to setup a keyboard with two
// text fields and how to manage their focused state.
//
// To use this keyboard, you must enable it in system settings
// ("Settings/General/Keyboards"). It needs full access to get
// access to features like haptic feedback.
// */
//class KeyboardViewController: KeyboardInputViewController {
//
//    /**
//     This function is called whenever the keyboard should be
//     created or updated. Here, we setup a `DemoKeyboardView`
//     as the main keyboard view.
//     */
//    override func viewWillSetupKeyboard() {
//        super.viewWillSetupKeyboard()
//
//        /// 💡 Make the demo use a ``DemoKeyboardView``.
//        ///
//        /// Note that we use a view builder-based `setup` to
//        /// get an `unowned` controller reference that helps
//        /// us avoid memory leaks caused by injecting `self`.
//        setup(with: DemoKeyboardView.init)
//    }
//}




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
struct DemoKeyboardView2: View {

    unowned var controller: KeyboardInputViewController
    
    @State private var showCustomKeyboard = true
    @State private var isContentVisible = false
    @State private var selectedLength = "Short"
    
    @State private var messageOutput = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: printHello) {
                    Text("Print Hello")
                }
                .font(.system(size: 20)) // Change the font size
                .foregroundColor(.white) // Change the text color
                .padding() // Add padding around the text
                .background(Color.blue) // Change the background color
                .cornerRadius(10)
                
                
                Button(action: {
                    isContentVisible.toggle()
                }) {
                    Text("Toggle Content")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.top, 20)
                
                
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
                
            
            if !showCustomKeyboard {
                VStack {
                    Button(action: {
                        replaceText()
                        showCustomKeyboard.toggle()
                    }) {
                        VStack(alignment: .leading) {
                            let words = messageOutput.split(separator: " ")
                            let maxWordsPerLine = 5
                            ForEach(0..<(words.count / maxWordsPerLine + 1)) { line in
                                Text(words[line*maxWordsPerLine..<min((line+1)*maxWordsPerLine, words.count)].joined(separator: " "))
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button(action: {
                        showCustomKeyboard.toggle()
                    }) {
                        Text("Toggle Keyboard")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            } else {
                SystemKeyboard(
                    controller: controller,
                    autocompleteToolbar: .none
                )
            }
        }.buttonStyle(.plain)
    }
    
    private func printHello() {
        
        let textBeingComposed = controller.keyboardContext.textDocumentProxy.documentContextBeforeInput ?? ""
        print("PRINT HELLO: \(textBeingComposed)")
        print(selectedLength)
        

        // Insert new text
        messageOutput = textBeingComposed + " luisda is here"
        
        showCustomKeyboard.toggle()
    }
    
    private func replaceText() {
        let textBeingComposed = controller.keyboardContext.textDocumentProxy.documentContextBeforeInput ?? ""

//        // Delete the existing text
//        let deleteOffset = -textBeingComposed.count
//        controller.keyboardContext.textDocumentProxy.adjustTextPosition(byCharacterOffset: deleteOffset)
        
        // Delete the existing text
        for _ in 0..<textBeingComposed.count {
            controller.keyboardContext.textDocumentProxy.deleteBackward()
        }

        controller.keyboardContext.textDocumentProxy.insertText(messageOutput)
        print("REPLACE TEXT: \(messageOutput)")
        
        messageOutput = ""
    }
}
