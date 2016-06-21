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
//	var parent:YAMLNode?

	
	// MARK: public routines
	
	func addChild(child:YAMLNode?) -> Void {
		children.append(child!)
    }
	
	
	func printDescription() -> Void {
		
		print("\"\(key)\":", terminator:"")
		
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
					print("{")
					node.printDescription()
					print("}")
					print(",")
				}
				print ("]")
				
				
			case .Unknown:
				print("Unknown node")
				
		}
		
	}
	
}