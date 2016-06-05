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
    
    public func parseStream (path:String, callback: (data:String) -> Void){
        let mode = "rb"
        
        let pathCString = path.cStringUsingEncoding(NSUTF8StringEncoding)!
        let modeCString = mode.cStringUsingEncoding(NSUTF8StringEncoding)!
        
        let fileHandler:UnsafeMutablePointer<FILE> = fopen(pathCString, modeCString)
        
        var parser = yaml_parser_t()
        var token = yaml_token_t()
        
        yaml_parser_initialize(&parser)
        yaml_parser_set_input_file(&parser, fileHandler)
        
        repeat {
            if yaml_parser_scan(&parser, &token) == 0 {
                print("Parser error %d\n", parser.error)
                exit(EXIT_FAILURE);
            }
            
            
            let spaces = String(count: Int.init(parser.indent) + 1, repeatedValue: (" " as Character))
            print(spaces, terminator:"")
            
            
            switch(token.type)
            {
                /* Stream start/end */
                case YAML_STREAM_START_TOKEN: print("STREAM START"); break;
                case YAML_STREAM_END_TOKEN:   print("STREAM END");   break;
                    /* Token types (read before actual token) */
                case YAML_KEY_TOKEN:   print("(Key token)   "); break;
                case YAML_VALUE_TOKEN: print("(Value token) "); break;
                    /* Block delimeters */
                case YAML_BLOCK_SEQUENCE_START_TOKEN: print("Start Block (Sequence)");
                case YAML_BLOCK_ENTRY_TOKEN:          print("Start Block (Entry)");
                case YAML_BLOCK_END_TOKEN:            print("End block</b>");
                    /* Data */
                case YAML_BLOCK_MAPPING_START_TOKEN:
                    print("[Block mapping]");
                case YAML_SCALAR_TOKEN:
                    print("scalar \(scalarToString(token.data.scalar)) ")
                
                    /* Others */
                default:
                    print("Got token of type %d\n", token.type);
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
}
