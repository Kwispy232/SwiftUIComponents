import SwiftUI

/// A flexible and customizable input field component
public struct InputView: View {
    
    /// Input field state
    public enum InputState {
        /// Default state
        case normal
        /// Error state
        case error
    }
    
    // MARK: - Properties
    
    @Binding private var text: String
    @FocusState private var isFocused: Bool
    private let placeholder: String
    private let label: String?
    private let helperText: String?
    private let state: InputState
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let trailingAction: (() -> Void)?
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let autocorrection: Bool
    private let onSubmit: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Initialize a new input field
    /// - Parameters:
    ///   - text: Binding to the text value
    ///   - placeholder: Placeholder text
    ///   - label: Optional label text
    ///   - helperText: Optional helper text
    ///   - state: The field state
    ///   - leadingIcon: Optional leading icon
    ///   - trailingIcon: Optional trailing icon
    ///   - trailingAction: Optional action for trailing icon
    ///   - isSecure: Whether the field is for secure entry
    ///   - keyboardType: Keyboard type
    ///   - textContentType: Text content type for autofill
    ///   - autocapitalization: Text autocapitalization
    ///   - autocorrection: Whether autocorrection is enabled
    ///   - onSubmit: Optional action to perform on submit
    public init(
        text: Binding<String>,
        placeholder: String,
        label: String? = nil,
        helperText: String? = nil,
        state: InputState = .normal,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        trailingAction: (() -> Void)? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocorrection: Bool = true,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.helperText = helperText
        self.state = state
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.trailingAction = trailingAction
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocorrection = autocorrection
        self.onSubmit = onSubmit
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DimensionTokens.Spacing.xs) {
            if let label = label {
                Text(label)
                    .dsFont(FontTokens.Label.s)
                    .foregroundColor(labelColor)
            }
            
            HStack(spacing: DimensionTokens.Spacing.xs) {
                if let leadingIcon = leadingIcon {
                    leadingIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(iconColor)
                        .padding(.leading, DimensionTokens.Spacing.s)
                }
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .dsFont(FontTokens.Body.m)
                            .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
                            .submitLabel(.done)
                            .focused($isFocused)
                            .onSubmit {
                                onSubmit?()
                            }
                    } else {
                        TextField(placeholder, text: $text)
                            .dsFont(FontTokens.Body.m)
                            .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
                            .submitLabel(.done)
                            .focused($isFocused)
                            .onSubmit {
                                onSubmit?()
                            }
                    }
                }
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .disableAutocorrection(!autocorrection)
                .padding(.vertical, DimensionTokens.Spacing.s)
                .padding(.leading, leadingIcon == nil ? DimensionTokens.Spacing.s : 0)
                
                if let trailingIcon = trailingIcon {
                    Button(action: {
                        trailingAction?()
                    }) {
                        trailingIcon
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
                    .stroke(isFocused && state != .error ? ColorTokens.Surface.brand : borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            
            if let helperText = helperText, state == .error {
                Text(helperText)
                    .dsFont(FontTokens.Label.s)
                    .foregroundColor(helperTextColor)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.3), value: state)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var labelColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralXXHigh
        case .error:
            return ColorTokens.Surface.danger
        }
    }
    
    private var borderColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralLow
        case .error:
            return ColorTokens.Surface.danger
        }
    }
    
    private var helperTextColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralMedium
        case .error:
            return ColorTokens.Surface.danger
        }
    }
    
    private var iconColor: Color {
        switch state {
        case .normal:
            return ColorTokens.Content.onNeutralMedium
        case .error:
            return ColorTokens.Surface.danger
        }
    }
    
}

// MARK: - Preview

#Preview {
    VStack(spacing: DimensionTokens.Spacing.m) {
        InputView(
            text: .constant(""),
            placeholder: "Enter your name",
            label: "Name",
            helperText: "Please enter your full name"
        )
        
        InputView(
            text: .constant(""),
            placeholder: "Enter your email",
            label: "Email",
            helperText: "Invalid email format",
            state: .error,
            leadingIcon: Image(systemName: "envelope")
        )
        
        InputView(
            text: .constant("john@example.com"),
            placeholder: "Enter your email",
            label: "Email",
            helperText: "Email verified",
            leadingIcon: Image(systemName: "envelope"),
            trailingIcon: Image(systemName: "checkmark.circle.fill")
        )
        
        InputView(
            text: .constant(""),
            placeholder: "Enter your password",
            label: "Password",
            isSecure: true,
            keyboardType: .default,
            textContentType: .password,
            autocorrection: false
        )
    }
    .padding()
}
