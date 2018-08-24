PropertyObservable
----------

When using pure Swift class, there is no KVO mechanism on stored property. It is also possible to use **didSet** closure but it is not flexible in the end.

In this project, there is a class call **Property**. **Property** is a generic class and also a proxy for your stored property. We can use **Property** to wrap any value type, like Int, String, Float etc. Then, we use **observe(_:)** function to monitor value change event.

The **observe(_:)** function also returns a *receipt* after registering the observation. We can use this *receipt* to invalidate the observation just by invoking **invalidate()** function on the *receipt*.


How To Use
----------

### Observe Value Change

```swift
struct Bob {
    let age: Property<Int> = Property<Int>(0)
}

let bob = BOB()
bob.age <<< 30  // custom infix operator for setting value
let observerReceipt = bob.age.observe { (new, old) in
    print("Bob's is getting old on his new age \(new). He was \(old) last year")
}
bob.age <<< 31
```

### Invalidate Observation

```swift
observerReceipt.invalidate()

```

### Custom Operator

When setting or getting value from **Property**, we can use **set(_:)** or **get()** to do so. However, we can also use custom operator to set value and get value.

```swift
// Setter
bob.age.set(30)
// is equivalent to
bob.age <<< 30

// Getter
_ = bob.age.get()
// is equivalent to 
_ = <<<bob.age 
// Be aware that no space after <<<

```
