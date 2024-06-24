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

func toastBread(_ bread: String,
                completion: @escaping (String) -> Void)
{
    DispatchQueue.global().async {
        sandwichMakerSays("Toasting the bread... Standing by...", waitFor: 5)
        completion("Crispy \(bread)")
    }
}

func slice(_ ingredients: [String],
        completion: @escaping ([String]) -> Void)
{
    DispatchQueue.global().async {
        let result = ingredients.map { ingredient in
            sandwichMakerSays("Slicing \(ingredient)", waitFor: 1)
            return "sliced \(ingredient)"
        }
        completion(result)
    }
}

func makeSandwich(bread: String, ingredients: [String], condiments: [String],
                  completion: @escaping (String) -> Void) {
  sandwichMakerSays("Preparing your sandwich...")
    
  toastBread(bread) { toasted in
    slice(ingredients) { sliced in
      sandwichMakerSays("Spreading \(condiments.joined(separator: ", and ")) om \(toasted)")
      sandwichMakerSays("Layering \(sliced.joined(separator: ", "))")
      sandwichMakerSays("Putting lettuce on top")
      sandwichMakerSays("Putting another slice of bread on top")
      
      completion("\(ingredients.joined(separator: ", ")), \(condiments.joined(separator: ", ")) on \(toasted)")
    }
  }
}

sandwichMakerSays("Hello to Cafe Complete, where we handle your order with care.")
sandwichMakerSays("Please place your order.")

let clock = ContinuousClock()
let start = clock.now
makeSandwich(bread: "Rye", ingredients: ["Cucumbers", "Tomatoes"], condiments: ["Mayo", "Mustard"]) { sandwich in
  customerSays("Hmmm.... this looks like a delicious \(sandwich) sandwich!")
  
  let time = clock.now - start
  print("Making this sandwich took \(time)")
}

print("The end.")
