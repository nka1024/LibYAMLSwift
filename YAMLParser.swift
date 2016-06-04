//
//  Parser.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyaschiy on 04.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import yaml

typealias scalar_t = yaml_event_t.__Unnamed_union_data.__Unnamed_struct_scalar

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
        var event = yaml_event_t()
        
        yaml_parser_initialize(&parser)
        yaml_parser_set_input_file(&parser, fileHandler)
        
        repeat {
            if yaml_parser_parse(&parser, &event) == 0 {
                print("Parser error %d\n", parser.error)
                exit(EXIT_FAILURE);
            }
            
            switch(event.type) {
                case YAML_NO_EVENT: print("No event!")
                
                /* Stream start/end */
                case YAML_STREAM_START_EVENT:   print("STREAM START")
                case YAML_STREAM_END_EVENT:     print("STREAM END")
                
                /* Block delimeters */
                case YAML_DOCUMENT_START_EVENT: print("Start Document")
                case YAML_DOCUMENT_END_EVENT:   print("End Document")
                case YAML_SEQUENCE_START_EVENT: print("Start Sequence")
                case YAML_SEQUENCE_END_EVENT:   print("End Sequence")
                case YAML_MAPPING_START_EVENT:  print("Start Mapping")
                case YAML_MAPPING_END_EVENT:    print("End Mapping")
                
                /* Data */
                case YAML_ALIAS_EVENT:
                    print("Got alias (anchor: \(event.data.alias.anchor)");
                case YAML_SCALAR_EVENT:
                    
                    print("Got scalar (value: \(scalarToString(event.data.scalar)))")
                
                
            default: print("Uknown event");
            }
            
            if event.type != YAML_STREAM_END_EVENT {
                yaml_event_delete(&event);
            }
        } while event.type != YAML_STREAM_END_EVENT
        
        yaml_event_delete(&event);
        
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
