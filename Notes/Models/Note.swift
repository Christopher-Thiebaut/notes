//
//  Note.swift
//  Notes
//
//  Created by Christopher Thiebaut on 1/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

class Note: Equatable, Codable {
    
    var title: String?
    var text: String?
    
    init(title: String?, text: String?) {
        self.title = title
        self.text = text
    }
    
    init(title: String){
        self.title = title
    }
    
    init(text: String){
        self.text = text
    }
    
    //MARK: Equatable
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.title == rhs.title && lhs.text == rhs.text
    }
}
