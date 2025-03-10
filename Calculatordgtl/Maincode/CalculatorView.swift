//
//  CalculatorView.swift
//  Calculatordgtl
//
//  Created by Ak B on 3/7/25.
//

import SwiftUI

enum CalcButton: String, Hashable {
    case clear = "AC"
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case divide = "÷"
    
    case four = "4"
    case five = "5"
    case six = "6"
    case multiply = "×"
    
    case one = "1"
    case two = "2"
    case three = "3"
    case subtract = "-"
    
    case zero = "0"
    case decimal = "."
    case equal = "="
    case add = "+"
    
    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .sin, .cos, .tan:
            return Color(.lightGray)
        default:
            return Color(UIColor.darkGray)
        }
    }
}

struct CalculatorView: View {
    @State private var display = "0"
    @State private var history = ""
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    // Define the grid layout for buttons.
    let buttons: [[CalcButton]] = [
        [.sin, .cos, .tan, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.clear, .zero, .decimal, .equal]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            // Display the history (if any)
            if !history.isEmpty && history != "0" {
                HStack {
                    Spacer()
                    Text(history)
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
            // Main display area for the current expression/result.
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            // Button grid.
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        Button(action: { buttonTapped(button) }) {
                            Text(button.rawValue)
                                .font(.system(size: 32))
                                .frame(width: buttonWidth(for: button),
                                       height: buttonHeight())
                                .background(button.backgroundColor)
                                .foregroundColor(.white)
                                .cornerRadius(orientation.isLandscape ? 13 : buttonWidth(for: button) / 2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
   
    func buttonTapped(_ button: CalcButton) {
        switch button {
        case .clear:
            display = "0"
            history = ""
        case .decimal:
            if !display.contains(".") {
                display.append(".")
            }
        case .equal:
            history = display
            // Insert missing parentheses for trig functions (e.g. "sin90" -> "sin(90)")
            let withParens = insertMissingParentheses(display)
            // Process trig calls to compute their numeric values.
            let processedExpr = processTrigFunctions(withParens)
            // Convert integers to floats before evaluation.
            let floatProcessed = convertIntegersToFloats(processedExpr)
            // Call the Objective‑C method from the Calculator framework.
            let result = Calculator.evaluateExpression(floatProcessed)
            display = formatResult(result)
        default:
            let input = button.rawValue
            if display == "0" {
                display = input
            } else {
                display.append(input)
            }
        }
    }
    
  
    
    // Inserts missing parentheses in trig calls, e.g. converts "sin90" to "sin(90)"
    func insertMissingParentheses(_ expr: String) -> String {
        let pattern = "(sin|cos|tan)(?!\\()(-?\\d+(?:\\.\\d+)?)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return expr }
        let range = NSRange(expr.startIndex..., in: expr)
        return regex.stringByReplacingMatches(in: expr, options: [], range: range, withTemplate: "$1($2)")
    }
    
    // Processes each trig function call by extracting the number inside parentheses,
    // computing the value and replacing the call with its computed value.
    func processTrigFunctions(_ expr: String) -> String {
        let pattern = "(sin|cos|tan)\\((-?\\d+(?:\\.\\d+)?)\\)"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return expr }
        let nsRange = NSRange(expr.startIndex..., in: expr)
        var newExpr = expr
        let matches = regex.matches(in: expr, options: [], range: nsRange)
        
        // Process matches in reverse order so that string indices remain valid.
        for match in matches.reversed() {
            guard let funcRange = Range(match.range(at: 1), in: newExpr),
                  let argRange = Range(match.range(at: 2), in: newExpr) else { continue }
            
            let funcName = String(newExpr[funcRange])
            let argString = String(newExpr[argRange])
            guard let arg = Double(argString) else { continue }
            
            let computed: Double
            switch funcName {
            case "sin": computed = calculateSin(arg)
            case "cos": computed = calculateCos(arg)
            case "tan": computed = calculateTan(arg)
            default: computed = 0
            }
            
            let replacement = formatResult(computed)
            if let fullRange = Range(match.range, in: newExpr) {
                newExpr.replaceSubrange(fullRange, with: replacement)
            }
        }
        return newExpr
    }
    
    // Converts integer numbers in the expression to floating‑point numbers (by appending ".0")
    // to ensure NSExpression performs floating‑point arithmetic.
    func convertIntegersToFloats(_ expr: String) -> String {
        let numberPattern = try! NSRegularExpression(pattern: "[-+]?(\\d+\\.\\d*|\\.\\d+|\\d+)")
        let matches = numberPattern.matches(in: expr, options: [], range: NSRange(location: 0, length: expr.utf16.count))
        var newExpr = ""
        var currentIndex = 0
        for match in matches {
            let matchRange = match.range
            let matchStart = matchRange.location
            let matchEnd = matchStart + matchRange.length
            
            // Append substring from current index to the start of the match.
            if currentIndex < matchStart {
                let start = expr.index(expr.startIndex, offsetBy: currentIndex)
                let end = expr.index(expr.startIndex, offsetBy: matchStart)
                newExpr += String(expr[start..<end])
            }
            
            // Get the matched number string.
            let start = expr.index(expr.startIndex, offsetBy: matchStart)
            let end = expr.index(expr.startIndex, offsetBy: matchEnd)
            let matchStr = String(expr[start..<end])
            
            // If the number lacks a decimal point, append ".0".
            var modifiedStr = matchStr
            if !modifiedStr.contains(".") {
                modifiedStr += ".0"
            }
            
            newExpr += modifiedStr
            currentIndex = matchEnd
        }
        
        // Append any remaining part of the expression.
        if currentIndex < expr.utf16.count {
            let start = expr.index(expr.startIndex, offsetBy: currentIndex)
            newExpr += String(expr[start...])
        }
        
        return newExpr
    }
    
    // Formats the computed result
    func formatResult(_ result: Double) -> String {
        let threshold = 1e-10
        if abs(result) < threshold { return "0" }
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(result))"
        }
        return "\(result)"
    }
    
   
    func buttonWidth(for button: CalcButton) -> CGFloat {
        let spacing: CGFloat = 12
        let baseDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let baseWidth = (baseDimension - (5 * spacing)) / 4
        return orientation.isLandscape ? baseWidth * 1.8 : baseWidth
    }
    
    func buttonHeight() -> CGFloat {
        let spacing: CGFloat = 12
        let baseDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let baseWidth = (baseDimension - (5 * spacing)) / 4
        return orientation.isLandscape ? baseWidth * 0.5 : baseWidth
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculatorView().previewInterfaceOrientation(.portrait)
            CalculatorView().previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
