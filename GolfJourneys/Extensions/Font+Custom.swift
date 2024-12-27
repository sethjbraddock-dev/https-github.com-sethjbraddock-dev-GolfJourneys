import SwiftUI

extension Font {
    static func registerCustomFonts() {
        guard let fontURL = Bundle.main.url(forResource: "Memimas", withExtension: "ttf"),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Could not load font")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font: \(error.debugDescription)")
        }
    }
} 