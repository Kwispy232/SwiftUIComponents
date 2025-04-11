# SwiftUI Components Library

A modern, customizable SwiftUI component library for iOS 18+ that provides a comprehensive design system with colors, typography, spacing, and radius tokens.

## Features

- 🎨 **Design Tokens**: Consistent design tokens for colors, typography, spacing, and radius
- 🧩 **UI Components**: Ready-to-use SwiftUI components that follow the design system
- 📱 **iOS 18+ Support**: Built specifically for the latest iOS version
- 🔤 **Custom Fonts**: Includes Inter font family (Regular, Medium, SemiBold)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftUIComponents.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. Go to File > Add Packages...
2. Enter the repository URL: `https://github.com/yourusername/SwiftUIComponents.git`
3. Select the version you want to use

## Usage

### Design Tokens

The library provides various design tokens that you can use in your app:

#### Colors

```swift
import SwiftUIComponents

// Use surface colors
Text("Hello, World!")
    .foregroundColor(ColorTokens.Content.onNeutralXXHigh)
    .background(ColorTokens.Surface.xLow)
```

#### Typography

```swift
import SwiftUIComponents

// Initialize the fonts (call this in your App's init method)
FontTokens.registerFonts()

// Use typography styles with proper line height and kerning
Text("Heading")
    .dsFont(FontTokens.Label.m)

Text("Body text")
    .dsFont(FontTokens.Body.m)

// Apply paragraph spacing
Text("First paragraph")
    .dsFont(FontTokens.Body.m)
    .dsParagraphSpacing()

// Apply list spacing
ForEach(items, id: \.self) { item in
    Text(item)
        .dsFont(FontTokens.Body.m)
        .dsListSpacing()
}
```

#### Spacing and Radius

```swift
import SwiftUIComponents

VStack(spacing: DimensionTokens.Spacing.m) {
    // Content with medium spacing
}
.padding(DimensionTokens.Spacing.l)

RoundedRectangle(cornerRadius: DimensionTokens.Radius.standard)
```

### Components

The library includes custom text field components:

#### Text Field

```swift
import SwiftUIComponents

// Standard text field
DSTextField(
    text: $text,
    placeholder: "Enter text",
    label: "Name"
)

// Text field with helper text
DSTextField(
    text: $email,
    placeholder: "Enter email",
    label: "Email",
    helperText: "We'll never share your email"
)

// Error state
DSTextField(
    text: $username,
    placeholder: "Enter username",
    label: "Username",
    helperText: "Username already taken",
    state: .error
)

// Text field with icons
DSTextField(
    text: $search,
    placeholder: "Search",
    leadingIcon: Image(systemName: "magnifyingglass"),
    trailingIcon: Image(systemName: "xmark.circle.fill"),
    trailingAction: { search = "" }
)
```

#### Password Field

```swift
import SwiftUIComponents

// Standard password field
DSPasswordField(
    text: $password,
    placeholder: "Enter password",
    label: "Password"
)

// Password field with helper text
DSPasswordField(
    text: $password,
    placeholder: "Enter password",
    label: "Password",
    helperText: "Must be at least 8 characters"
)

// Password field with icon
DSPasswordField(
    text: $password,
    placeholder: "Enter password",
    label: "Password",
    leadingIcon: Image(systemName: "lock")
)

// Password field without visibility toggle
DSPasswordField(
    text: $password,
    placeholder: "Enter password",
    showPasswordToggle: false
)
```

## Requirements

- iOS 18.0+
- Swift 6.0+
- Xcode 16.0+

## License

This library is available under the MIT license.
