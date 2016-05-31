//
//  AchievementDescription.swift
//  SwiftyGameCenter
//
//  Created by Joseph Duffy on 31/05/2016.
//  Copyright © 2016 Yetii Ltd. All rights reserved.
//

import Foundation
import GameKit

public class AchievementDescription {
    /**
     A common image for incomplete achievements.
     
     - returns: An image for use when the achievement is incomplete
    */
    public class func incompleteAchievementImage() -> Image {
        return GKAchievementDescription.incompleteAchievementImage()
    }

    /**
     A common image for completed achievements.
     
     - returns: An image for use when the achievement is complete
    */
    public class func placeholderCompletedAchievementImage() -> Image {
        return GKAchievementDescription.placeholderCompletedAchievementImage()
    }

    /// The underlying achievement description
    public let _achievemenetDescription: GKAchievementDescription

    /// A unique string used to identify the achievement.
    public var identifier: String? {
        get {
            return _achievemenetDescription.identifier
        }
    }

    /// The identifier for the group the achievement description is part of.
    public var groupIdentifier: String? {
        get {
            return _achievemenetDescription.groupIdentifier
        }
    }

    /// A localized title for the achievement.
    public var title: String? {
        get {
            return _achievemenetDescription.title
        }
    }

    /// A localized description to be used after the local player has completed the achievement.
    public var achievedDescription: String? {
        get {
            return _achievemenetDescription.achievedDescription
        }
    }

    /// A localized description of the achievement to be used when the local player has not completed the achievement.
    public var unachievedDescription: String? {
        get {
            return _achievemenetDescription.unachievedDescription
        }
    }

    /// The number of points the player earns by completing this achievement.
    public var maximumPoints: Int {
        get {
            return _achievemenetDescription.maximumPoints
        }
    }

    /**
     A Boolean value that states whether this achievement is initially visible to players. (read-only)

     If the value of this property is false, this achievement is always visible to the player. If true,
     the achievement is not displayed in any of the standard achievement user interface screens. It remains
     hidden until the first time your game reports progress towards completing this achievement.
    */
    public var hidden: Bool {
        get {
            return _achievemenetDescription.hidden
        }
    }

    /**
     A Boolean value that states whether this achievement can be earned multiple times. (read-only)

     If the value of this property is false, then the achievement may only be earned once. After the achievement
     is earned, Game Center ignores any further progress submitted for it. If the value of this property is true,
     then the achievement is considered earned each time your game reports progress to Game Center that completes
     the achievement. This means that any appropriate banners are displayed to the player again, challenges based
     on the achievement are completed, and so on.
    */
    public var replayable: Bool {
        get {
            return _achievemenetDescription.replayable
        }
    }

    /**
     The achievement this object describes. Requires an identifier to be set on the object and that the
     achievement is in `AchievementsManager`'s cache
    */
    public var achievement: Achievement? {
        get {
            guard let identifier = identifier else { return nil }

            return AchievementsManager.sharedInstance[identifier]
        }
    }

    /**
     A cache of the image to be used when the acheivement is complete. Image is loaded by
     loadImageWithCompletionHandler and will be nil until this function is complete
    */
    public private(set) var image: Image?

    public init(achievementDescription: GKAchievementDescription) {
        _achievemenetDescription = achievementDescription
    }

    /**
     Loads the image for use when the achievement is complete. Image wille be returned from the cache
     if the image has already loaded.
     
     - SeeAlso: `AchievementDescription.image`
     - SeeAlso: `GKAchievementDescription.loadImageWithCompletionHandler`
    */
    public func loadImageWithCompletionHandler(completionHandler: ((Image?, NSError?) -> Void)?) {
        if let image = image {
            completionHandler?(image, nil)
            return
        }

        _achievemenetDescription.loadImageWithCompletionHandler { [weak self] (image, error) in
            guard let `self` = self else { return }

            self.image = image
            
            completionHandler?(image, error)
        }
    }
}
