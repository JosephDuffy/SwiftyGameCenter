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
public typealias Image = UIImage

#elseif os(OSX)
import AppKit

public typealias ViewController = NSViewController
public typealias Image = NSImage

#endif
