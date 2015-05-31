//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Nathan Weller on 5/21/15.
//  Copyright (c) 2015 Nathan Weller. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}