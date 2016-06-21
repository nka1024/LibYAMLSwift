//
//  YAMLNode.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyashchiy on 05.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import Foundation

enum YAMLNodeType  {
	case Unknown
	case Mapping
    case Sequence
    case Scalar
}

class YAMLNode  {
    
	var key:String = "_"
	var type:YAMLNodeType = YAMLNodeType.Unknown
	
	var children:Array<YAMLNode> = []
	var value:String?
	
	// MARK: public routines
	
	func addChild(child:YAMLNode?) -> Void {
		children.append(child!)
    }
	
	
	func printDescription() -> Void {
		
		print("\"\(key)\":", terminator:"")
		
		printValue()
	}
	
	func printValue() -> Void {
		
		switch type {
			case .Scalar:
				print("\"\(value!)\"")
				
			case .Mapping:
				print ("{", terminator:"")
				for node in children {
					node.printDescription()
					print(",")
				}
				print ("}")
				
			case .Sequence:
				print ("[", terminator:"")
				for node in children {
					
					node.printValue()
					
					print(",")
				}
				print ("]")
				
				
			case .Unknown:
				print("Unknown node")
				
		}
		
	}
	
	func nativeObject() -> AnyObject? {
		
		switch type {
			case .Scalar:
				return value!
			
			case .Mapping:
				var object = Dictionary<String, AnyObject>()
				
				for node in children {
					object[node.key] = node.nativeObject()
				}
				
				return object
				
			case .Sequence:
				
				var object = Array<AnyObject>()
				
				for node in children {
					object.append(node.nativeObject()!)
				}
			return object
			
			case .Unknown:
				return self
				
		}
		return nil
	}

	
}