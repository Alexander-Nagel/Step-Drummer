/// Rounds to specified number of decimals.
/// - Parameters:
///   - input: Double to be rounded
///   - digits: number of decimal digits to round
/// - Returns: Rounded Double with specified number of decimal digits
func round (_ input: Double, toDigits digits: Int) -> Double {
    
    return Double(String(format: "%0.\(digits)f", input)) ?? 0
}
