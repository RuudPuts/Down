//
//  DvrResponse.swift
//  Down
//
//  Created by Ruud Puts on 12/01/2018.
//  Copyright © 2018 Mobile Sorcery. All rights reserved.
//

class DvrResponse<T>: Response<T> {
    let data: T?
    let message: String
    let result: String
    
    init(data: T?, message: String, result: String) {
        self.data = data
        self.message = message
        self.result = result
    }
}
