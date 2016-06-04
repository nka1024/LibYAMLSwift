//
//  Parser.swift
//  LibYAMLSwift
//
//  Created by Kirill Nepomnyaschiy on 04.06.16.
//  Copyright © 2016 Kirill Nepomnyaschiy. All rights reserved.
//

import yaml;

public class YAMLParser {


    public init() {
        // perform some initialization here
    }
    public func yamlGetVersionString() -> String? {
       
        let version = yaml_get_version_string()
        return String.fromCString(version)
    }

}
