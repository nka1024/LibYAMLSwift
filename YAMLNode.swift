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
    
	var key   :String
	var value :AnyObject
	
    var type  :YAMLNodeType
	var parent:YAMLNode?
	
	init (key:String, value:AnyObject?, type:YAMLNodeType, parent:YAMLNode?) {
        
        self.type   = type
        self.parent = parent
		self.key    = key
		
		switch type {
			case YAMLNodeType.YAMLNodeTypeMapping:   self.value = Dictionary<String, YAMLNode>()
			case YAMLNodeType.YAMLNodeTypeSequence:  self.value = Array<AnyObject>()
			case YAMLNodeType.YAMLNodeTypeScalar:    self.value = value!
		}
    }
    
	func addChild(child:YAMLNode) -> Void {
		
		switch type {
			case YAMLNodeType.YAMLNodeTypeMapping:
				let value:Dictionary<String, AnyObject> = self.value as! Dictionary<String, AnyObject>
				self.value.setValue(child, forKey: child.key)
			
			case YAMLNodeType.YAMLNodeTypeSequence:
				let value:Array<AnyObject> = self.value as! Array<AnyObject>
				self.value.addObject(child)
			
			case YAMLNodeType.YAMLNodeTypeScalar:
				print("Error: trying to add child to scalar node")
		}
    }
	
}