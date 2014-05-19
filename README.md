# NTYAirData

[![Version](http://cocoapod-badges.herokuapp.com/v/NTYAirData/badge.png)](http://cocoadocs.org/docsets/NTYAirData)
[![Platform](http://cocoapod-badges.herokuapp.com/p/NTYAirData/badge.png)](http://cocoadocs.org/docsets/NTYAirData)

## Installation

NTYAirData is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```rb
pod "NTYAirData"
```

## Usage

```objective-c
AIRDataServer *server = [[AIRDataServer alloc] initWithManagedObjectContext:context managedObjectModel:model];
[server start];
```

By default, a HTTP server runs in your application at `80` port on devices or `8080` on simulators. You can change the port by `startWithPort:`.

### RESTful API

The server has RESTful APIs for data managed by Core Data. If your application have `User` entity, the server will have below APIs.

```sh
GET    /users     - request the collection of user objects
GET    /users/:id - request an user object specified by :id
POST   /users     - create a new user object
PUT    /users/:id - update an user object specified by :id
DELETE /users/:id - destroy an user object specified by :id
```

The server will response data in the format of JSON like below.

```json
[
  {
    "id": 1,
    "name": "Alice",
    "age": 18
  },
  {
    "id": 2,
    "name": "Bob",
    "age": 19
  },
  {
    "id": 3,
    "name": "Charlie",
    "age": 20
  }
]
```

