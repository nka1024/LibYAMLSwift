//
//  Parser.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyaschiy on 04.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import yaml

typealias scalar_t = yaml_token_s.__Unnamed_union_data.__Unnamed_struct_scalar

public class YAMLParser {
	
	var stack:Array<YAMLNode> = []
	
    // MARK: Initialization
    
    public init() {
        
    }

    
    // MARK: Version
    
    public func yamlGetVersionString() -> String? {
        let version = yaml_get_version_string()
        return String.fromCString(version)
    }

    public func yamlGetVersion() -> (major: Int32, minor: Int32, patch: Int32)? {
        var major:Int32 = 0;
        var minor:Int32 = 0;
        var patch:Int32 = 0;
        
        yaml_get_version(&major, &minor, &patch)
        
        return (major, minor, patch)
    }
    
    
    // MARK: Stream parse
    
    public func parseStream (path:String, callback: (data:AnyObject) -> Void){
		
		func push(node:YAMLNode?) -> Void {
			if (node != nil) {
				stack.append(node!)
			}
		}
		
		func pop() -> YAMLNode? {
			if (stack.count > 0) {
				let node = stack.removeLast()
				
				if (stack.count == 0) {
					dispatchNode(node)
					return makeParentNode()
				}
				
				return node
			} else {
				return nil
			}
		}
	
		func dispatchNode(node:YAMLNode) -> Void {
			
			callback(data:node.nativeObject()!)
			
//			print("{")
//			node.printDescription()
//			print("}")
			
//			let result = parent?.nativeObject()
//			print(result)
		}
		
        let mode = "rb"
        
        let pathCString = path.cStringUsingEncoding(NSUTF8StringEncoding)!
        let modeCString = mode.cStringUsingEncoding(NSUTF8StringEncoding)!
        
        let fileHandler:UnsafeMutablePointer<FILE> = fopen(pathCString, modeCString)
        
        var parser = yaml_parser_t()
        var token = yaml_token_t()
        
        yaml_parser_initialize(&parser)
        yaml_parser_set_input_file(&parser, fileHandler)
		
		var node = makeParentNode()
		var lastKey:String? = "parent"
		var lastTokenType = 0;
		
		
		var sequence:YAMLNode? = nil
		
		repeat {
            if yaml_parser_scan(&parser, &token) == 0 {
                print("Parser error %d\n", parser.error)
                exit(EXIT_FAILURE);
            }
			
			if (lastTokenType == 1) {
				let spaces = String(count: Int.init(parser.indent) + 1, repeatedValue: (" " as Character))
				print(spaces, terminator:"")
			}
			
            switch(token.type)
            {
                /* Stream start/end */
                case YAML_STREAM_START_TOKEN: noop()
                case YAML_STREAM_END_TOKEN:   noop()
				
				/* Token types (read before actual token) */
                case YAML_KEY_TOKEN:
					lastTokenType = 0;
				
                case YAML_VALUE_TOKEN:
					lastTokenType = 1;
				
                    /* Block delimeters */
                case YAML_BLOCK_SEQUENCE_START_TOKEN:
//					print("Start Block (Sequence)");
					noop()
				
                case YAML_BLOCK_ENTRY_TOKEN:
//					print("Start Block (Entry)");
					sequence = node
					push(node)
					node?.type = .Sequence
				
                case YAML_BLOCK_END_TOKEN:
//					print("End block</b>");
				
					node = pop()
					if (sequence != nil) {
						sequence = nil
					}
				
	
				/* Data */
                case YAML_BLOCK_MAPPING_START_TOKEN:
//					print("[Block mapping]");

					if (sequence != nil ) {
						node = YAMLNode()
						sequence?.addChild(node)
					}
					
					node?.type = YAMLNodeType.Mapping

				
                case YAML_SCALAR_TOKEN:
					lastKey = scalarToString(token.data.scalar)

//					if (lastTokenType == 0) {
//						print("\"\(lastKey!)\":")
//					}
//					else {
//						print("\"\(lastKey!)\":")
//					}
					
					if (node?.type == .Sequence) {
						sequence = nil
						node = pop();
					}
					
					if (lastTokenType == 0) {
						
						let parent = node
						push(node)
						
						node = YAMLNode()
						node?.key = lastKey ?? ""
						
						parent?.addChild(node)
					}
					else {
						node?.value = lastKey
						node?.type = YAMLNodeType.Scalar
						
						node = pop()
					}
				
                    /* Others */
                default:
                    print("Got token of type %d\n", token.type)
            }
			
            if token.type != YAML_STREAM_END_TOKEN {
                    yaml_token_delete(&token);
            }
	
        }
        while token.type != YAML_STREAM_END_TOKEN
		
		yaml_token_delete(&token);
        yaml_parser_delete(&parser);
        
        fclose(fileHandler);
    }
	
        
    // MARK: Private routines
    
    func scalarToString(scalar:scalar_t) -> String? {
        let len = scalar.length
        let ptr = scalar.value
    
        return cStringToString(ptr, length: len)
    }
    
    func cStringToString(ptr: UnsafeMutablePointer<UInt8>, length len: Int) -> String? {
        if let theString = NSString(bytes: ptr, length: len, encoding: NSUTF8StringEncoding) {
            return theString as String
        } else {
            return nil
        }
    }
	
	
	
	func noop() -> Void {
		
	}
	
	func makeParentNode() -> YAMLNode? {
		var node:YAMLNode? = YAMLNode()
		node?.type = .Mapping
		return node
	}
	

}
