import SwiftUI

public protocol FontDisplayable {
    var name: String { get }

    func font(size: CGFloat, relativeTo: Font.TextStyle) -> Font
}

public extension FontDisplayable {
    func font(size: CGFloat, relativeTo style: Font.TextStyle) -> Font {
        Font.custom(name, size: size, relativeTo: style)
    }
}

public extension UIFont {
    static func register(from url: URL) {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else { return }
        guard let font = CGFont(fontDataProvider) else { return }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            print("Error registering font from \(url): \(error.debugDescription)")
            return
        }
    }
}
