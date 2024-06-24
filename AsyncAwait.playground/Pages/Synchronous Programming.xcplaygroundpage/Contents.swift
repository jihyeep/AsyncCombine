import Foundation

public func customerSays(_ message: String) {
    print("[Customer] \(message)")
}

public func sandwichMakerSays(_ message: String, waitFor time: UInt32 = 0) {
    print("[Sandwich maker] \(message)")
    if time > 0 {
        print("     ... this will take \(time)s")
        sleep(time)
    }
}

func toastBread(_ bread: String) -> String {
    sandwichMakerSays("Toasting the bread... Standing by...", waitFor: 5)
    return "Crispy \(bread)"
}

func slice(_ ingredients: [String]) -> [String] {
    let results = ingredients.map { ingredient in
        sandwichMakerSays("Slicing \(ingredient)", waitFor: 1)
        return "Sliced \(ingredient)"
    }
    return results
}

func makeSandwich(bread: String, ingredients: [String], condiments: [String]) -> String {
    sandwichMakerSays("Preparing your sandwich...")
    let toasted = toastBread(bread)
    let sliced = slice(ingredients)
    sandwichMakerSays("Spreading \(condiments.joined(separator: ", and"))") /// 배열을 separator와 문자열로 변환
    sandwichMakerSays("Putting lettuce on top")
    sandwichMakerSays("Putting another slice of bread on top")
    return "\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(toasted)"
}

sandwichMakerSays("Hello to Cafe Synchronous, where we execute your order serially.")
sandwichMakerSays("Please place your order.")

let clock = ContinuousClock()
let time = clock.measure {
  let sandwich = makeSandwich(bread: "Rye", ingredients: ["Cucumbers", "Tomatoes"], condiments: ["Mayo", "Mustard"])
  customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
}

print("Making this sandwich took \(time)")
