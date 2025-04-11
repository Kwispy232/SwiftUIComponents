import SwiftUI
import CoreText
import CoreGraphics

/// Font tokens for the design system
public enum FontTokens {
    
    // MARK: - Label Styles
    
    /// Label typography styles
    public enum Label {
        /// Medium label style
        /// - Family: Inter
        /// - Size: 16px
        /// - Weight: 500
        /// - Line height: 22px
        /// - Letter spacing: 0.16px
        public static let m = Font.custom("Inter-Medium", size: 16, relativeTo: .body)
        
        /// Small label style
        /// - Family: Inter
        /// - Size: 14px
        /// - Weight: 550
        /// - Line height: 17px
        /// - Letter spacing: 0.16px
        public static let s = Font.custom("Inter-SemiBold", size: 14, relativeTo: .callout)
    }
    
    // MARK: - Body Styles
    
    /// Body typography styles
    public enum Body {
        /// Medium body style
        /// - Family: Inter
        /// - Size: 16px
        /// - Weight: 400
        /// - Line height: 22px
        /// - Letter spacing: 0.01px
        public static let m = Font.custom("Inter-Regular", size: 16, relativeTo: .body)
    }
    
    // MARK: - Font Registration
    
    /// Register custom fonts with the system
    public static func registerFonts() {
        registerFont(bundle: .module, fontName: "Inter-Regular", fontExtension: "otf")
        registerFont(bundle: .module, fontName: "Inter-Medium", fontExtension: "otf")
        registerFont(bundle: .module, fontName: "Inter-SemiBold", fontExtension: "otf")
    }
    
    /// Register a font with the system
    /// - Parameters:
    ///   - bundle: The bundle containing the font
    ///   - fontName: The name of the font file without extension
    ///   - fontExtension: The extension of the font file
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("Failed to find font: \(fontName).\(fontExtension)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            if let error = error?.takeRetainedValue() {
                print("Failed to register font: \(fontName).\(fontExtension), error: \(error)")
            } else {
                print("Failed to register font: \(fontName).\(fontExtension)")
            }
        }
    }
}

// MARK: - Typography Constants

/// Typography constants for the design system
public enum TypographyConstants {
    
    /// Paragraph spacing for body text
    public static let paragraphSpacing: CGFloat = 20
    
    /// List item spacing
    public static let listSpacing: CGFloat = 6
    
}

// MARK: - Font Modifiers

/// Extension to apply typography styles with proper line spacing and tracking
extension View {
    
    /// Applies a design system font with correct spacing properties
    /// - Parameter font: The design system font to apply
    /// - Returns: Modified view with proper typography styling
    public func dsFont(_ font: Font) -> some View {
        self.modifier(DSFontModifier(font: font))
    }
    
    /// Applies paragraph spacing to text content
    /// - Returns: Modified view with proper paragraph spacing
    public func dsParagraphSpacing() -> some View {
        self.modifier(DSParagraphSpacingModifier())
    }
    
    /// Applies list spacing to list items
    /// - Returns: Modified view with proper list spacing
    public func dsListSpacing() -> some View {
        self.modifier(DSListSpacingModifier())
    }
}

/// Modifier that applies design system font with proper spacing
private struct DSFontModifier: ViewModifier {
    
    let font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .lineSpacing(lineSpacingForFont(font))
            .tracking(kerningForFont(font)) // tracking = kerning in SwiftUI
    }
    
    private func lineSpacingForFont(_ font: Font) -> CGFloat {
        switch font {
        case FontTokens.Label.m:
            return 6 // 22px - 16px
        case FontTokens.Label.s:
            return 3 // 17px - 14px
        case FontTokens.Body.m:
            return 6 // 22px - 16px
        default:
            return 0
        }
    }
    
    /// Returns the kerning (letter spacing) value for the given font
    private func kerningForFont(_ font: Font) -> CGFloat {
        switch font {
        case FontTokens.Label.m, FontTokens.Label.s:
            return 0.16 // Letter spacing for labels
        case FontTokens.Body.m:
            return 0.01 // Letter spacing for body text
        default:
            return 0
        }
    }
    
}

/// Modifier that applies paragraph spacing to text content
private struct DSParagraphSpacingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, TypographyConstants.paragraphSpacing)
    }
    
}

/// Modifier that applies list spacing to list items
private struct DSListSpacingModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, TypographyConstants.listSpacing)
    }
    
}
