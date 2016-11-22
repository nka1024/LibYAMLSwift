//
//  YAMLNode.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyashchiy on 05.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import Foundation

enum YAMLNodeType  {
	case unknown
	case mapping
    case sequence
    case scalar
}

class YAMLNode  {
    
	var key:String = "_"
	var type:YAMLNodeType = YAMLNodeType.unknown
	
	var children:Array<YAMLNode> = []
	var value:String?
	
	// MARK: public routines
	
	func addChild(_ child:YAMLNode?) -> Void {
		children.append(child!)
    }
	
	
	func printDescription() -> Void {
		
		print("\"\(key)\":", terminator:"")
		
		printValue()
	}
	
	func printValue() -> Void {
		
		switch type {
			case .scalar:
				print("\"\(value!)\"")
				
			case .mapping:
				print ("{", terminator:"")
				for node in children {
					node.printDescription()
					print(",")
				}
				print ("}")
				
			case .sequence:
				print ("[", terminator:"")
				for node in children {
					
					node.printValue()
					
					print(",")
				}
				print ("]")
				
				
			case .unknown:
				print("Unknown node")
				
		}
		
	}
	
	func nativeObject() -> AnyObject? {
		
		switch type {
			case .scalar:
				return value! as AnyObject?
			
			case .mapping:
				var object = Dictionary<String, AnyObject>()
				
				for node in children {
					object[node.key] = node.nativeObject()
				}
				
				return object as AnyObject?
				
			case .sequence:
				
				var object = Array<AnyObject>()
				
				for node in children {
					object.append(node.nativeObject()!)
				}
			return object as AnyObject?
			
			case .unknown:
				return self
				
		}
		return nil
	}

	
}
