//
//  YAMLNode.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyashchiy on 05.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import Foundation

enum YAMLNodeType  {
    case YAMLNodeTypeMapping
    case YAMLNodeTypeSequence
    case YAMLNodeTypeScalar
}

class YAMLNode  {
    
    var data:AnyObject
    var type:YAMLNodeType
    
    init (type:YAMLNodeType, parent:YAMLNode) {
        
        self.type = type
        
        if (type == YAMLNodeType.YAMLNodeTypeMapping || type == YAMLNodeType.YAMLNodeTypeScalar) {
            data = Dictionary<String, YAMLNode>()
        }
        else if (type == YAMLNodeType.YAMLNodeTypeSequence) {
            data = Array<AnyObject>()
        }
        else {
            data = 0
        }
    }
    
    func addScalar(key:String, value:AnyObject) -> Void {
        
        if (type == YAMLNodeType.YAMLNodeTypeMapping || type == YAMLNodeType.YAMLNodeTypeScalar) {
            data = Dictionary<String, YAMLNode>()
        }
        else if (type == YAMLNodeType.YAMLNodeTypeSequence) {
            data = Array<AnyObject>()
        }
        else {
            data = 0
        }
    }
    
    func addMapping(key:String, value:YAMLNode) -> Void {
        
        if (type == YAMLNodeType.YAMLNodeTypeMapping || type == YAMLNodeType.YAMLNodeTypeScalar) {
            data = Dictionary<String, YAMLNode>()
        }
        else if (type == YAMLNodeType.YAMLNodeTypeSequence) {
            data = Array<AnyObject>()
        }
        else {
            data = 0
        }
    }
}