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
    // sleep하는 동안 Task가 취소될 수 있어서, sleep은 task가 취소되면 에러를 뱉어내서 task를 탈출시키므로 try?를 써줌
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

    let toasted = await toastBread(bread)
    let sliced = await slice(ingredients)

    sandwichMakerSays("Spreading \(condiments.joined(separator: ", and ")) om \(toasted)")
    sandwichMakerSays("Layering \(sliced.joined(separator: ", "))")
    sandwichMakerSays("Putting lettuce on top")
    sandwichMakerSays("Putting another slice of bread on top")

    return "\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(toasted)"

}

let clock = ContinuousClock()

sandwichMakerSays("Hello to Cafe Async, where we execute your order in asynchronously.")
sandwichMakerSays("Please place your order.")

Task {
  let time = await clock.measure {
    let sandwich = await makeSandwich(bread: "Rye", ingredients: ["Cucumbers", "Tomatoes"], condiments: ["Mayo", "Mustard"])
    customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
    print("The end.")
  }
  print("Making this sandwich took \(time)")
}
