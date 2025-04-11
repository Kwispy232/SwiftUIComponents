import SwiftUI

/// Dimension tokens for the design system
public enum DimensionTokens {
    
    // MARK: - Radius
    
    /// Radius tokens for corners
    public enum Radius {
        /// Input field radius - 12px
        public static let input: CGFloat = 12
        
        /// Standard radius for most components - 12px
        public static let standard: CGFloat = 12
    }
    
    // MARK: - Spacing
    
    /// Spacing tokens for layout
    public enum Spacing {
        /// Extra small spacing - 8px
        public static let xs: CGFloat = 8
        
        /// Small spacing - 12px
        public static let s: CGFloat = 12
        
        /// Medium spacing - 16px
        public static let m: CGFloat = 16
        
        /// Large spacing - 20px
        public static let l: CGFloat = 20
        
        /// Paragraph spacing - 20px
        public static let paragraph: CGFloat = 20
        
        /// List item spacing - 6px
        public static let list: CGFloat = 6
    }
}
