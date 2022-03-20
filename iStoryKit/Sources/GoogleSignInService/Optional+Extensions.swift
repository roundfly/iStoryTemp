
extension Optional where Wrapped == String {
    var unwrapOrBlank: String {
        guard let self = self else { return "" }
        return self
    }
}
