import Foundation

// Create `originalValues` Array<Int>
var originalValues = [22, 4, 5, 9, 45]

// Create `newValues` Array<Int>
var newValues = originalValues.shuffled()

print("NewValues: \(newValues)")

// Get the `CollectionDifference<Int>` and assign to `diff`
let diff = newValues.difference(from: originalValues)

// Loop and display differences
// There are two cases `insert` and `remove`, which each has `offset`, `element` and `associatedWith`
diff.forEach { change in
    switch change {
    case .insert(let offset, let element, let associatedWith):
        print("INSERT -> offset: \(offset), element: \(element), associatedWith: \(String(describing: associatedWith))")
    case .remove(let offset, let element, let associatedWith):
        print("REMOVED -> offset: \(offset), element: \(element), associatedWith: \(String(describing: associatedWith))")
    }
}

// Create a new collection by applying the differences
var newCollection = originalValues.applying(diff)

// Print em out
print("New Collection: \(newCollection ?? [])")
