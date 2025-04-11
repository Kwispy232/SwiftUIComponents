import SwiftUI

/// A custom password field component that follows the design system
public struct DSPasswordField: View {
    
    /// Password field state
    public enum FieldState {
        /// Default state
        case normal
        /// Error state
        case error
        /// Success state
        case success
    }
    
    // MARK: - Properties
    
    @Binding private var text: String
    @State private var isSecure: Bool = true
    private let placeholder: String
    private let label: String?
    private let helperText: String?
    private let state: FieldState
    private let showPasswordToggle: Bool
    private let leadingIcon: Image?
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    
    // MARK: - Initialization
    
    /// Initialize a new password field
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - placeholder: Placeholder text
    ///   - label: Optional label text
    ///   - helperText: Optional helper text
    ///   - state: The field state
    ///   - showPasswordToggle: Whether to show the password visibility toggle
    ///   - leadingIcon: Optional leading icon
    ///   - keyboardType: Keyboard type
    ///   - textContentType: Text content type for autofill
    public init(
        text: Binding<String>,
        placeholder: String,
        label: String? = nil,
        helperText: String? = nil,
        state: FieldState = .normal,
        showPasswordToggle: Bool = true,
        leadingIcon: Image? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = .password
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.helperText = helperText
        self.state = state
        self.showPasswordToggle = showPasswordToggle
        self.leadingIcon = leadingIcon
        self.keyboardType = keyboardType
        self.textContentType = textContentType
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DimensionTokens.Spacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .dsFont(FontTokens.Label.s)
                    .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
            }
            
            // Password field container
            HStack(spacing: DimensionTokens.Spacing.xs) {
                // Leading icon
                if let leadingIcon = leadingIcon {
                    leadingIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(iconColor)
                        .padding(.leading, DimensionTokens.Spacing.s)
                }
                
                // Password field
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .dsFont(FontTokens.Body.m)
                            .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
                            .keyboardType(keyboardType)
                            .textContentType(textContentType)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        TextField(placeholder, text: $text)
                            .dsFont(FontTokens.Body.m)
                            .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
                            .keyboardType(keyboardType)
                            .textContentType(textContentType)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }
                .padding(.vertical, DimensionTokens.Spacing.s)
                .padding(.leading, leadingIcon == nil ? DimensionTokens.Spacing.s : 0)
                
                // Password visibility toggle
                if showPasswordToggle {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye" : "eye.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(iconColor)
                    }
                    .padding(.trailing, DimensionTokens.Spacing.s)
                }
            }
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: DimensionTokens.Radius.input)
                    .fill(ColorTokens.Surface.xLow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DimensionTokens.Radius.input)
                    .stroke(borderColor, lineWidth: 1)
            )
            
            // Helper text
            if let helperText = helperText {
                Text(helperText)
                    .dsFont(FontTokens.Label.s)
                    .foregroundColor(helperTextColor)
            }
            
            // Password strength indicator (optional)
            if !text.isEmpty {
                passwordStrengthIndicator
            }
        }
    }
    
    // MARK: - Password Strength Indicator
    
    @ViewBuilder
    private var passwordStrengthIndicator: some View {
        VStack(alignment: .leading, spacing: DimensionTokens.Spacing.xs) {
            Text(passwordStrengthText)
                .dsFont(FontTokens.Label.s)
                .foregroundColor(passwordStrengthColor)
            
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    ForEach(0..<4, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < passwordStrength ? passwordStrengthColor : ColorTokens.Content.onNeutralLow.opacity(0.3))
                            .frame(width: (geometry.size.width - 12) / 4, height: 4)
                    }
                }
            }
            .frame(height: 4)
        }
        .padding(.top, DimensionTokens.Spacing.xs)
    }
    
    // MARK: - Helper Methods
    
    private var borderColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralLow
        case .error:
            return ColorTokens.Surface.danger
        case .success:
            return ColorTokens.Surface.brand
        }
    }
    
    private var helperTextColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralMedium
        case .error:
            return ColorTokens.Surface.danger
        case .success:
            return ColorTokens.Surface.brand
        }
    }
    
    private var iconColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralMedium
        case .error:
            return ColorTokens.Surface.danger
        case .success:
            return ColorTokens.Surface.brand
        }
    }
    
    // Password strength calculation (simplified)
    private var passwordStrength: Int {
        let length = text.count
        
        if length == 0 {
            return 0
        } else if length < 6 {
            return 1
        } else if length < 8 {
            return 2
        } else if length < 10 || !containsSpecialCharacters(text) {
            return 3
        } else {
            return 4
        }
    }
    
    private var passwordStrengthText: String {
        switch passwordStrength {
        case 0:
            return "No password"
        case 1:
            return "Weak"
        case 2:
            return "Fair"
        case 3:
            return "Good"
        case 4:
            return "Strong"
        default:
            return ""
        }
    }
    
    private var passwordStrengthColor: Color {
        switch passwordStrength {
        case 0, 1:
            return ColorTokens.Surface.danger
        case 2:
            return ColorTokens.Surface.warning
        case 3, 4:
            return ColorTokens.Surface.brand
        default:
            return ColorTokens.Content.onNeutralMedium
        }
    }
    
    private func containsSpecialCharacters(_ string: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_-+=[]{}|:;,.<>?/~`")
        return string.rangeOfCharacter(from: specialCharacterSet) != nil
    }
    
}

// MARK: - Preview

#Preview {
    VStack(spacing: DimensionTokens.Spacing.m) {
        DSPasswordField(
            text: .constant(""),
            placeholder: "Enter your password",
            label: "Password",
            helperText: "Must be at least 8 characters"
        )
        
        DSPasswordField(
            text: .constant("pass123"),
            placeholder: "Enter your password",
            label: "Password",
            helperText: "Password is too weak",
            state: .error,
            leadingIcon: Image(systemName: "lock")
        )
        
        DSPasswordField(
            text: .constant("StrongP@ssw0rd!"),
            placeholder: "Enter your password",
            label: "Password",
            helperText: "Password meets requirements",
            state: .success,
            leadingIcon: Image(systemName: "lock")
        )
        
        DSPasswordField(
            text: .constant("HiddenP@ss"),
            placeholder: "Enter your password",
            showPasswordToggle: false
        )
    }
    .padding()
}
