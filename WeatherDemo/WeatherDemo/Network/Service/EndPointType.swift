//
//  EndPointType.swift
//  NetWorkLayer
//
//  Created by Peide Xiao on 11/2/23.
//  Copyright © 2023 Peide Xiao. All rights reserved.
//

import UIKit

public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


enum HTTPTask {
    case request
    case requestParameters(bodyParameters:Parameters?, urlParameters:Parameters?)
    case requestParametersAndHeaders(bodyParameters:Parameters?, urlParameters:Parameters?,additionalHeader:HTTPHeaders?)
    case uploadData(bodyParameters:Parameters?, fileParameters: Parameters?, additionalHeader:HTTPHeaders?)
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}


enum Result<String> {
    case success
    case failure(String)
}
