//
//  Result.swift
//  Vybes
//
//  Created by Willie Johnson on 4/6/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

/// Handles the response of a resource request.
public enum Result<T> {
  case success(T)
  case failure(Any)
}

public enum VoidResponse {
  case success
  case failure(Any)
}

public typealias AnyResult = (Result<Any>) -> Void
public typealias BoolResult = (Result<Bool>) -> Void
public typealias StringResult = (Result<String>) -> Void
public typealias ImagesResult = (Result<Images>) -> Void
public typealias UIImageResult = (Result<UIImage>) -> Void
public typealias VoidResult = (VoidResponse) -> Void
