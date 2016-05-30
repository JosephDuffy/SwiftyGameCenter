//
//  Manager.swift
//  SwiftyGameCenter
//
//  Created by Joseph Duffy on 30/05/2016.
//  Copyright © 2016 Yetii Ltd. All rights reserved.
//

import Foundation
import GameKit

/// The manager of the SwiftyGameCenter classes. Can be used to
/// authenticate the local player and auto-load achievements
public class Manager {
    /// The shared instance of the Manager object
    public static let sharedInstance = Manager()

    /// If set to true (default), achievements will be
    /// loaded once the local player is authenticated
    public var autoLoadAchievements = true

    /// A flag that is set to true while the local player is
    /// being authenticated
    public private(set) var authenticatingPlayer = false

    /// The authenticated local player, or nil if the player
    /// is not authenticated. Check `authenticationViewController`
    /// for a possible view controller to be displayed
    public private(set) var localPlayer: GKLocalPlayer?

    /// The view controller to display to the user. This view controller
    /// is provided by Game Center and will prompt the user to authenticate.
    /// The `authenticateLocalPlayer(_:)` function sets this property
    /// in the `authenticationHandler` function
    public private(set) var authenticationViewController: ViewController?

    /// Private init to ensure only 1 instance is created
    private init() {}

    /// Authenticate the local game center player. Authenticates via `GKLocalPlayer`
    /// by setting the `authenticateHandler` property. `completionHandler` is called
    /// after authentication is complete. Error will be nil if authentication succeeded
    public func authenticateLocalPlayer(completionHandler: ((AuthenticationError?) -> Void)?) {
        guard !authenticatingPlayer else {
            completionHandler?(.AlreadyAuthenticating)

            return
        }

        authenticatingPlayer = true

        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { [weak self] (viewController, error) in
            guard let `self` = self else { return }

            self.authenticatingPlayer = false
            self.authenticationViewController = viewController

            if let error = error {
                // An error occured
                completionHandler?(.GameCenterError(underlyingError: error))
            } else if let viewController = viewController {
                completionHandler?(.NotAuthenticated(viewController: viewController))
            } else if localPlayer.authenticated {
                self.localPlayer = localPlayer

                if self.autoLoadAchievements {
                    AchievementsManager.sharedInstance.loadAchievements(nil)
                }

                completionHandler?(nil)
            } else {
                completionHandler?(.UnknownError)
            }
        }
    }
}

/// An error returned in the completion handler of the
/// `authenticateLocalPlayer(:_)` method of `Manager`
public enum AuthenticationError: ErrorType {
    /// Indicates that the local user is already being authenticated
    case AlreadyAuthenticating

    /// Indicates that the user could not be authenticated. You
    /// should present the view controller if you require the
    /// user to authenticate. Value will also be set on the
    /// `authenticationViewController` property of `Manager`
    case NotAuthenticated(viewController: ViewController)

    /// Indicates that Game Center returned an error
    case GameCenterError(underlyingError: NSError)

    /// Indicates an unknown error occured. This is used when
    /// error is nil, view controller is nil, and the user
    /// is not authenticated
    case UnknownError
}
