import SwiftUI

/// A specialized password input component with validation and requirements display
public struct PasswordInput: View {
    
    // MARK: - Password Validation
    
    /// Password requirement type
    public enum PasswordRequirement: String, CaseIterable, Identifiable {
        /// Minimum 8 characters
        case minLength = "Minimálne 8 znakov"
        /// At least one uppercase letter
        case uppercase = "Aspoň jedno veľké písmeno"
        /// At least one number
        case number = "Aspoň jedno číslo"
        /// At least one special character
        case special = "Aspoň jeden špeciálny znak"
        
        public var id: String { rawValue }
    }
    
    // MARK: - Properties
    
    @Binding private var password: String
    @State private var isPasswordVisible: Bool = false
    
    private let label: String
    private let placeholder: String
    private let helperText: String?
    private let showRequirements: Bool
    private let leadingIcon: Image?
    private let onSubmit: (() -> Void)?
    
    // MARK: - Computed Properties
    
    private var passwordState: InputView.InputState {
        if password.isEmpty || allRequirementsMet {
            return .normal
        } else {
            return .error
        }
    }
    
    private var allRequirementsMet: Bool {
        return PasswordRequirement.allCases.allSatisfy { requirementMet($0) }
    }
    
    // MARK: - Initialization
    
    /// Initialize a new password input
    /// - Parameters:
    ///   - password: Binding to the password value
    ///   - label: Label text
    ///   - placeholder: Placeholder text
    ///   - helperText: Optional helper text
    ///   - showRequirements: Whether to show password requirements
    ///   - leadingIcon: Optional leading icon
    ///   - onSubmit: Optional action to perform on submit
    public init(
        password: Binding<String>,
        label: String = "Heslo",
        placeholder: String = "Zadajte heslo",
        helperText: String? = nil,
        showRequirements: Bool = true,
        leadingIcon: Image? = nil,
        onSubmit: (() -> Void)? = nil
    ) {
        self._password = password
        self.label = label
        self.placeholder = placeholder
        self.helperText = helperText
        self.showRequirements = showRequirements
        self.leadingIcon = leadingIcon
        self.onSubmit = onSubmit
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DimensionTokens.Spacing.s) {
            InputView(
                text: $password,
                placeholder: placeholder,
                label: label,
                helperText: passwordState == .error ? helperText : nil,
                state: passwordState,
                leadingIcon: leadingIcon,
                trailingIcon: Image(systemName: isPasswordVisible ? "eye.slash" : "eye"),
                trailingAction: { isPasswordVisible.toggle() },
                isSecure: !isPasswordVisible,
                keyboardType: .default,
                textContentType: .newPassword,
                autocorrection: false,
                onSubmit: onSubmit
            )
            
            if showRequirements && !password.isEmpty {
                requirementsView
            }
        }
    }
    
    // MARK: - Requirements View
    
    private var requirementsView: some View {
        VStack(alignment: .leading, spacing: DimensionTokens.Spacing.xs) {
            ForEach(PasswordRequirement.allCases) { requirement in
                HStack(spacing: DimensionTokens.Spacing.xs) {
                    Image(systemName: requirementMet(requirement) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(requirementMet(requirement) ? ColorTokens.Surface.brand : ColorTokens.Content.onNeutralMedium)
                    
                    Text(requirement.rawValue)
                        .dsFont(FontTokens.Label.s)
                        .foregroundColor(requirementMet(requirement) ? ColorTokens.Content.onNeutralXXHigh : ColorTokens.Content.onNeutralMedium)
                }
            }
        }
        .padding(.leading, DimensionTokens.Spacing.xs)
        .animation(.easeInOut, value: password)
    }
    
    // MARK: - Helper Methods
    
    /// Check if a specific password requirement is met
    /// - Parameter requirement: The requirement to check
    /// - Returns: Whether the requirement is met
    private func requirementMet(_ requirement: PasswordRequirement) -> Bool {
        switch requirement {
        case .minLength:
            return password.count >= 8
        case .uppercase:
            return password.contains(where: { $0.isUppercase })
        case .number:
            return password.contains(where: { $0.isNumber })
        case .special:
            let specialCharacters = CharacterSet(charactersIn: "?=#/%!@$^&*()_-+[]{}|:;,.<>~`")
            return password.rangeOfCharacter(from: specialCharacters) != nil
        }
    }
    
}

// MARK: - Preview

#Preview {
    VStack(spacing: DimensionTokens.Spacing.m) {
        PasswordInput(
            password: .constant("")
        )
        
        PasswordInput(
            password: .constant("Pass1?1"),
            helperText: "Zadajte silné heslo"
        )
        
        PasswordInput(
            password: .constant("StrongPassword1?"),
            helperText: "Heslo spĺňa všetky požiadavky",
            showRequirements: false
        )
    }
    .padding()
}
