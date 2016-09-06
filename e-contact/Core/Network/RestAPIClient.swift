//
//  RestAPIClient.swift
//  e-contact
//
//  Created by Boris on 3/9/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import Alamofire

typealias ResponseHandler = ErrorResponse -> Void
typealias ImageUploadingSuccess = () -> Void
typealias ImageUploadingFailure = ErrorType -> Void


class RestAPIClient {

    // MARK: - Public Methods

    func executeRequest<T: APIRequestProtocol>(request: T,
                                               success: (T.Response -> Void)? = nil,
                                               failure: ResponseHandler? = nil) -> Request? {

        let requestPath = Constants.Networking.BaseURL + request.path

        return Alamofire.request(
            request.HTTPMethod,
            requestPath,
            parameters: request.parameters,
            headers: request.headers,
            encoding: .JSON) .responseJSON { response in
                switch response.result {
                case .Success:
                    ResponseParser.parseResponse(response, request: request, success: success, failure: failure)

                case .Failure(let error):
                    failure?(
                        ErrorResponse(
                            statusCode: StatusCode(rawValue: error.code) ?? .BadRequest,
                            message: error.description
                        )
                    )
                }
            }
    }

    func executeMultipartUpload(method: MultipartImageUpload,
                                success: ImageUploadingSuccess,
                                failure: ImageUploadingFailure) {

        Alamofire.upload(method.HTTPMethod,
                         Constants.Networking.BaseURL + method.path,
                         headers: method.headers,
                         multipartFormData: method.multipartFormData,
                         encodingMemoryThreshold: Constants.ImageUploader.MemoryThreshold,
                         encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseData(completionHandler: { response in
                    switch response.result {
                    case .Success:
                        success()

                    case .Failure(let error):
                        failure(error)
                      }
                })
                break
            case .Failure(let error):
                failure(error)
                break
            }
        })
    }

    func stopAllRequests() {
        Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler {
            [unowned self] dataTasks, uploadTasks, downloadTasks in
            self.cancel(dataTasks)
            self.cancel(uploadTasks)
            self.cancel(downloadTasks)
        }
    }

    private func cancel(tasks: [NSURLSessionTask]) {
        for task in tasks {
            task.cancel()
        }
    }

}
