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
NTYAirDataServer *server = [[NTYAirDataServer alloc] initWithManagedObjectContext:context];
[server addResource:[NTYResourceDescription resourceForEntityName:@"User" resourceKey:@"name"]];
[server addResource:[NTYResourceDescription resourceForEntityName:@"Article" resourceKey:@"uid"]];
[server start];
```

By default, a HTTP server runs in your application at `80` port on devices or `8080` port on simulators. You can change the port by `startWithPort:`.

`NTYResourceDescription` describes a resource served by the server. `resourceKey` is used to identify a resource because objects managed by Core Data have no primary key.

### RESTful API

The server has RESTful APIs for data managed by Core Data. If your application have `User` entity, the server will have below APIs.

```sh
GET    /users.json               - get the collection of user objects
GET    /users/:resource_key.json - get an user object identified by :resource_key
POST   /users.json               - create a new user object
```

The server will response data in the format of JSON like below.

```sh
$ curl http://192.168.1.10/users.json
[
  {
    "age": 18,
    "name": "Alice"
  },
  {
    "age": 19,
    "name": "Bob"
  },
  {
    "age": 20,
    "name": "Charlie"
  }
]
```

```sh
$ curl http://192.168.1.10/users/Alice.json
{
  "age": 18,
  "name": "Alice"
}
```
