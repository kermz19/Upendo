//
//  Contact.swift
//  Upendo2
//
//  Created by Kerwin Charles on 4/1/18.
//  Copyright © 2018 Kerwin Charles. All rights reserved.
//

import Foundation


class Contact{
    
    private var _name = "";
    private var _id = "";
    
    init (id: String, name: String){
        _id = id;
        _name = name;
    }
    
    var name: String {
        return _name;
    }
    var id: String{
        return _id;
    }
}
