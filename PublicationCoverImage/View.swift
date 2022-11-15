
import Foundation
import SwiftUI

extension View {
    @ViewBuilder func hidden(_ hide: Bool) -> some View {
        switch hide {
        case true: hidden()
        case false: self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    ///
    /// Taken from https://www.avanderlee.com/swiftui/conditional-view-modifier/
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func ifLet<T, Content: View>(_ optional: @autoclosure () -> T?, transform: (T, Self) -> Content) -> some View {
        if let value = optional() {
            transform(value, self)
        } else {
            self
        }
    }
}
