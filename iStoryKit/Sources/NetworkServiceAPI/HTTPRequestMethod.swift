//
// Copyright (c) 2021 iStory.com. All rights reserved.
//

import Foundation

/// HTTP request methods.
public enum RequestMethod: String {
    /// `GET` method requests a representation of the specified resource.
    /// Requests using `GET` should only retrieve data.
    case get = "GET"

    /// `POST` method is used to submit an entity to the specified resource,
    /// often causing a change in state or side effects on the server.
    case post = "POST"

    /// `PUT` method replaces all current representations of the target
    /// resource with the request payload.
    case put = "PUT"

    /// `DELETE` method deletes the specified resource.
    case delete = "DELETE"

    /// `PATCH` method is used to apply partial modifications to a resource.
    case patch = "PATCH"
}
