import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

public func customerSays(_ message: String) {
    print("[Customer] \(message)")
}

public func sandwichMakerSays(_ message: String, waitFor time: UInt32 = 0) {
    print("[Sandwich maker] \(message)")
    if time > 0 {
        print("                 ... this will take \(time)s")
        sleep(time)
    }
}
func toastBread(_ bread: String) async -> String {
    sandwichMakerSays("Toasting the bread... Standing by...")
    try? await Task.sleep(nanoseconds: 5_000_000_000)
    return "Crispy \(bread)"
}

func slice(_ ingredients: [String]) async -> [String] {
    var results = [String]()
    for ingredient in ingredients {
        sandwichMakerSays("Slicing \(ingredient)")
        try? await Task.sleep(for: .seconds(1))
        results.append("sliced \(ingredient)")
    }
    return results
}

func makeSandwich(bread: String, ingredients: [String], condiments: [String]) async -> String {
    sandwichMakerSays("Preparing your sandwich...")
    
    // 비동기 처리 - 알아서 작업이 진행되다가 마지막에 완료된 작업에 맞춰 작업이 끝남
    async let toasted = toastBread(bread)
    async let sliced = slice(ingredients)

    sandwichMakerSays("Spreading \(condiments.joined(separator: ", and ")) om \(await toasted)")
    sandwichMakerSays("Layering \(await sliced.joined(separator: ", "))")
    sandwichMakerSays("Putting lettuce on top")
    sandwichMakerSays("Putting another slice of bread on top")

    return "\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(await toasted)"

}

let clock = ContinuousClock()

sandwichMakerSays("Hello to Cafe Async Let, where we execute your order in parallel.")
sandwichMakerSays("Please place your order.")

Task {
    let time = await clock.measure {
    let sandwich = await makeSandwich(bread: "Rye", ingredients: ["Cucumbers", "Tomatoes"], condiments: ["Mayo", "Mustard"])
    customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
    print("The end.")
  }
    
  print("Making this sandwich took \(time)") // prints "Making this sandwich took 5.331491 seconds"
}
