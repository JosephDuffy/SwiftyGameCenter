//
//  CrossPlatform.swift
//  SwiftyGameCenter
//
//  Created by Joseph Duffy on 30/05/2016.
//  Copyright © 2016 Yetii Ltd. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public typealias ViewController = UIViewController
#elseif os(OSX)
import AppKit

public typealias ViewController = NSViewController
#endif
