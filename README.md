# SwiftJSONRPC

[![CI Status](http://img.shields.io/travis/kolyasev/SwiftJSONRPC.svg?style=flat)](https://travis-ci.org/kolyasev/SwiftJSONRPC)
<!-- [![Version](https://img.shields.io/cocoapods/v/SwiftJSONRPC.svg?style=flat)](http://cocoapods.org/pods/SwiftJSONRPC) -->
<!-- [![License](https://img.shields.io/cocoapods/l/SwiftJSONRPC.svg?style=flat)](http://cocoapods.org/pods/SwiftJSONRPC) -->
<!-- [![Platform](https://img.shields.io/cocoapods/p/SwiftJSONRPC.svg?style=flat)](http://cocoapods.org/pods/SwiftJSONRPC) -->

## Usage

### Defining a Service

```swift
import SwiftJSONRPC

class UserService: JSONRPCService {
    func vote(rating: Int) -> ResultProvider<Int> {
        return invoke("vote", params: ["rating": rating])
    }
    
    func create(name: String) -> ResultProvider<UserModel> {
        return invoke("create", params: ["name": name])
    }

    // And other JSON-RPC methods
}
```

You can define as many services as you want depending on your requirements.

### Making a Request

```swift
// Init JSON-RPC client
let url = URL(string: "http://example.com/rpc")!
let client = RPCClient(url: url)

// Init JSON-RPC service
let service = MyService(client: client)

// Perform request
service.vote(rating: 5)
```

### Result Handling

```swift
service.vote(rating: 5).result { newRating in
    // Handle result
}
```

SwiftJSONRPC contains five different invocation callback types.

###### Result

```swift
func result(queue: ResultQueue = .background, block: @escaping (Result) -> Void) -> Self
```

Called on success result. Include generic response data type that you defined in `RPCService` subclass.

###### Error

```swift
func error(queue: ResultQueue = .background, block: @escaping (RPCError) -> Void) -> Self
```

Called on error result. Include instance of `RPCError` type.

###### Cancel

```swift
func cancel(queue: ResultQueue = .background, block: @escaping () -> Void) -> Self
```

Called if invocation was cancelled by calling `cancel()` method.

###### Start

```swift
func start(queue: ResultQueue = .background, block: @escaping () -> Void) -> Self
```

Called before performing invocation. Can be used for starting loading animation.

###### Finish

```swift
func finish(queue: ResultQueue = .background, block: @escaping () -> Void) -> Self
```

Called after performing invocation. In all cases including canceling. Can be used for stopping loading animation.

#### Chained Invocation Callbacks

Invocation callbacks can be chained:

```swift
service.vote(rating: 5)
    .result { newRating in
        // Handle result
    }
    .error { error in
        // Handle error
    }
    .start {
        // Setup activity indicator
    }
    .finish {
        // Remove activity indicator
    }
```

#### Invocation Callbacks Queue

By default invocation callback called on background queue. But you can specify custom queue for each callback:

```swift
service.vote(rating: 5)
    .result(queue: .background) { newRating in
        // Handle result
    }
    .error(queue: .main) { error in
        // Handle error
    }
```

Use one of available queue types:

```swift
enum ResultQueue
{
    case main
    case background
    case custom(queue: DispatchQueue)
}
```

#### Result Serialization

SwiftJSONRPC provides built-in result serialization for `Int`, `String`, `Bool` types.

##### `Parcelable` Protocol

To serialize your custom type result from JSON you can implement `Parcelable` protocol.

```swift
protocol Parcelable {
    init(params: [String: Any]) throws
}
```

For example:

```swift
struct UserModel: Parcelable {
    let id: String
    let name: String
    
    required init(params: [String: Any]) throws {
        // Parse params to struct
        // ...
    }
}
```

> You can use libraries like [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper), [MAPPER](https://github.com/LYFT/MAPPER) or other to adapt `Parcelable` protocol. Or you can adapt Swift 4 `Decodable`.

After that use this struct as `RPCService.Result` generic parameter:

```swift
class UserService: JSONRPCService {
    func create(name: String) -> ResultProvider<UserModel> {
        return invoke("create", params: ["name": name])
    }
}
```
```swift
service.create(name: "testuser").result { user in
    print("User created with ID = \(user.id)")
}
```

Using array of `Parcelable` objects is also supported:

```swift
extension UserService {
    func allUsers() -> ResultProvider<[UserModel]> {
        return invoke("all_users")
    }
}
```


## Advanced Usage

### Request Executor

## Requirements

## Installation

SwiftJSONRPC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftJSONRPC"
```

## ToDo

- [ ] Add support for notification request object without an "id" member.

## Author

Denis Kolyasev, kolyasev@gmail.com

## License

SwiftJSONRPC is available under the MIT license. See the LICENSE file for more info.
