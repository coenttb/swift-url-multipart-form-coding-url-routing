# Swift URL Multipart Form Coding URL Routing

A Swift library that provides multipart form data handling with seamless URLRouting integration, enabling type-safe file uploads and form processing.

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%2014%20|%20iOS%2017-blue.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

## Features

### 📁 **Multipart Form Data Handling**
- **RFC 7578 Compliant**: Standards-compliant multipart/form-data processing
- **File Upload Support**: Secure handling of file uploads with validation
- **Magic Number Validation**: Automatic file type verification using file signatures
- **Size Limits**: Configurable file size restrictions with sensible defaults
- **Predefined File Types**: Built-in support for images, documents, and more

### 🔗 **URLRouting Integration** 
- **Seamless Integration**: First-class support for Point-Free's URLRouting library
- **Conversion Protocol**: Easy integration with routing systems via the `Conversion` protocol
- **Type-Safe Routes**: Define routes with compile-time guarantees for multipart data handling
- **Swift 6 Compatibility**: Full support for Swift's latest concurrency and type safety features

## Quick Start

### Installation

Add `swift-url-multipart-form-coding-url-routing` to your Swift package:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-url-multipart-form-coding-url-routing.git", from: "0.0.1")
]
```

### Basic Multipart Form Handling

```swift
import URLRouting
import URLMultipartFormCodingURLRouting

// Define a form field
let textField = Multipart.FormField(
    name: "description",
    value: "User uploaded content"
)

// Use in route definition
let formRoute = Route {
    Method.post
    Path { "submit" }
    Body(textField.conversion)
}
```

### File Upload Handling

```swift
import URLRouting
import URLMultipartFormCodingURLRouting

// Define file upload for user avatars
let avatarUpload = Multipart.FileUpload(
    fieldName: "avatar",
    filename: "profile.jpg",
    fileType: .image(.jpeg),
    maxSize: 2 * 1024 * 1024  // 2MB limit
)

// Use in route definition
let uploadRoute = Route {
    Method.post
    Path { "upload"; "avatar" }
    Body(avatarUpload.conversion)
}

// The conversion automatically validates:
// ✅ File size limits
// ✅ JPEG magic number signature
// ✅ Content type matching
```

## Advanced Usage

### Custom File Types

```swift
import URLMultipartFormCoding

// Define custom file type with validation
let customFileType = Multipart.FileUpload.FileType(
    contentType: "application/json",
    fileExtension: "json"
) { data in
    // Custom validation logic
    _ = try JSONSerialization.jsonObject(with: data)
}

let jsonUpload = Multipart.FileUpload(
    fieldName: "config",
    filename: "settings.json", 
    fileType: customFileType,
    maxSize: 1024 * 1024  // 1MB limit
)
```

### Supported File Types

| Type | Content Type | Validation |
|------|-------------|------------|
| **JPEG** | `image/jpeg` | Magic number validation |
| **PNG** | `image/png` | PNG signature check |
| **PDF** | `application/pdf` | %PDF header validation |
| **Custom** | User-defined | Custom validation function |

## Core Components

### URLMultipartFormCoding

The foundation for multipart form data handling:

```swift
import URLMultipartFormCoding

// Basic form field
let field = Multipart.FormField(
    name: "username",
    value: "john_doe"
)

// File upload with validation
let upload = Multipart.FileUpload(
    fieldName: "document",
    filename: "report.pdf", 
    fileType: .pdf,
    maxSize: 5 * 1024 * 1024  // 5MB
)
```

### URLMultipartFormCodingURLRouting

Integration layer for URLRouting:

```swift
import URLMultipartFormCodingURLRouting

// Use form field in routes
let fieldRoute = Route {
    Method.post
    Path { "api"; "user" }
    Body(field.conversion)
}

// Use file upload in routes  
let uploadRoute = Route {
    Method.post
    Path { "api"; "upload" }
    Body(upload.conversion)
}
```

## Security Features

### File Upload Security

- **Magic Number Validation**: Prevents malicious files disguised as safe formats
- **Size Limits**: Configurable limits prevent DoS attacks via large files  
- **Content Type Validation**: Ensures uploaded content matches declared type
- **Safe Boundary Generation**: Cryptographically secure multipart boundaries

### Multipart Data Security

- **Field Validation**: Automatic validation of form field names and values
- **Memory Safety**: Efficient parsing that prevents buffer overflows
- **Input Sanitization**: Proper handling of multipart data with security considerations

## Error Handling

```swift
import URLMultipartFormCoding

do {
    let fileData = try fileUpload.conversion.apply(uploadData)
} catch let error as Multipart.FileUpload.ValidationError {
    switch error {
    case .fileTooLarge(let size, let limit):
        print("File too large: \(size) bytes, limit: \(limit)")
    case .invalidFileType(let expected, let actual):
        print("Invalid file type: expected \(expected), got \(actual)")
    case .emptyFile:
        print("Uploaded file is empty")
    case .invalidMagicNumber:
        print("File signature validation failed")
    }
}

do {
    let fieldData = try formField.conversion.apply(fieldData)
} catch {
    print("Form field processing failed: \(error)")
}
```

## Testing

The library includes comprehensive test suites:

```bash
swift test
```

Test coverage includes:
- ✅ Multipart form field processing
- ✅ File upload validation and security checks
- ✅ URLRouting integration and conversions
- ✅ Error handling scenarios
- ✅ Magic number validation for file types
- ✅ Size limit enforcement

## Requirements

- **Swift**: 6.0+
- **Platforms**: macOS 14.0+, iOS 17.0+
- **Dependencies**: 
  - [swift-url-form-coding](https://github.com/coenttb/swift-url-form-coding) (0.0.1+)
  - [swift-url-routing](https://github.com/pointfreeco/swift-url-routing) (0.6.0+)
  - [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) (1.1.5+)

## Related Projects

### The coenttb Stack

* [swift-url-form-coding](https://github.com/coenttb/swift-url-form-coding): URL form encoding/decoding foundation
* [swift-css](https://github.com/coenttb/swift-css): A Swift DSL for type-safe CSS
* [swift-html](https://github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS
* [swift-web](https://github.com/coenttb/swift-web): Foundational web development tools
* [coenttb-web](https://github.com/coenttb/coenttb-web): Enhanced web development functionality
* [coenttb-server](https://github.com/coenttb/coenttb-server): Modern server development tools

### PointFree Foundations

* [swift-url-routing](https://github.com/pointfreeco/swift-url-routing): Type-safe URL routing
* [swift-dependencies](https://github.com/pointfreeco/swift-dependencies): Dependency management system

## Contributing

Contributions are welcome! Please feel free to:

1. **Open Issues**: Report bugs or request features
2. **Submit PRs**: Improve documentation, add features, or fix bugs  
3. **Share Feedback**: Let us know how you're using the library

## License

This project is licensed under the **Apache 2.0 License**. See [LICENSE](LICENSE) for details.

## Feedback & Support

Your feedback makes this project better for everyone!

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Connect on LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)

---

**swift-url-multipart-form-coding-url-routing** - Type-safe multipart form data handling with URLRouting integration for modern Swift applications.
