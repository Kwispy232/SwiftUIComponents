import SwiftUI

/// Color tokens for the design system
public enum ColorTokens {
    
    // MARK: - Surface Colors
    
    /// Surface color tokens for backgrounds and containers
    public enum Surface {
        /// High contrast surface color - #8C8C9A
        public static let xHigh = Color(hex: "#8C8C9A")
        
        /// Low contrast surface color - #FFFFFF
        public static let xLow = Color(hex: "#FFFFFF")
        
        /// Brand surface color - #0050FF
        public static let brand = Color(hex: "#0050FF")
        
        /// Danger surface color - #DC2828
        public static let danger = Color(hex: "#DC2828")
        
        /// Danger variant surface color - #FFDCDC
        public static let dangerVariant = Color(hex: "#FFDCDC")
        
        /// Warning surface color - #A56315
        public static let warning = Color(hex: "#A56315")
        
        /// Warning variant surface color - #FAF1B6
        public static let warningVariant = Color(hex: "#FAF1B6")
    }
    
    // MARK: - Content Colors
    
    /// Content color tokens for text, icons, and other content elements
    public enum Content {
        /// High contrast content color - #2C2C31
        public static let onNeutralXXHigh = Color(hex: "#2C2C31")
        
        /// Medium contrast content color - #8C8C9A
        public static let onNeutralMedium = Color(hex: "#8C8C9A")
        
        /// Low contrast content color - #C9C9CE
        public static let onNeutralLow = Color(hex: "#C9C9CE")
        
        /// Danger content color - #DC2828
        public static let onNeutralDanger = Color(hex: "#DC2828")
        
        /// Warning content color - #A56315
        public static let onNeutralWarning = Color(hex: "#A56315")
    }
    
    // MARK: - State Colors
    
    /// State color tokens for interactive elements
    public enum State {
        /// Hover state color - 6% alpha
        public static let defaultHover = Color(hex: "#1A1A1A0F") // 6% opacity
        
        /// Focus state color - 80% alpha
        public static let defaultFocus = Color(hex: "#1A1A1ACC") // 80% opacity
    }
    
}

// MARK: - Color Extension

extension Color {
    
    /// Initialize a color with a hex string
    /// - Parameter hex: The hex string (e.g. "#FF0000")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}
