//
//  Achievement.swift
//  SwiftyGameCenter
//
//  Created by Joseph Duffy on 30/05/2016.
//  Copyright © 2016 Yetii Ltd. All rights reserved.
//

import GameKit

/// A wrapper for `GKAchievement`. Properties are synthesised
/// to the underlying `GKAchievement`
public class Achievement {
    /// The underlying `GKAchievement`
    let _achievement: GKAchievement

    internal(set) var reportStatus: AchievementReportStatus = .NotPending

    /**
     A string used to uniquely identify the specific achievement the object refers to.

     - SeeAlso: `GKAchievement.identifier`
    */
    public var identifier: String? {
        get {
            return _achievement.identifier
        }
        set {
            _achievement.identifier = newValue
        }
    }

    /**
     A percentage value that states how far the player has progressed on this achievement.
     
     When set, the `reportStatus` value is set to PendingReport
     
     - SeeAlso: `GKAchievement.percentComplete`
    */
    public var percentComplete: Double {
        get {
            return _achievement.percentComplete
        }
        set {
            _achievement.percentComplete = newValue
            reportStatus = .PendingReport
        }
    }

    /**
     A Boolean value that states whether the player has completed the achievement. (read-only)

     - SeeAlso: `GKAchievement.complete`
     */
    public var completed: Bool {
        get {
            return _achievement.completed
        }
    }

    /**
     The last time that progress on the achievement was successfully reported to Game Center. (read-only)

     - SeeAlso: `GKAchievement.lastReportedDate`
     */
    public var lastReportedDate: NSDate {
        get {
            return _achievement.lastReportedDate
        }
    }

    /**
     A Boolean value that states whether a banner is displayed when the achievement is completed.

     - SeeAlso: `GKAchievement.showsCompletionBanner`
     */
    public var showsCompletionBanner: Bool {
        get {
            return _achievement.showsCompletionBanner
        }
    }

    /**
     A GKPlayer object used to identify the player who earned the achievement. (read-only)

     - SeeAlso: `GKAchievement.player`
     */
    @available(OSX 10.10, *)
    public var player: GKPlayer {
        get {
            return _achievement.player
        }
    }

    internal init(achievement: GKAchievement) {
        self._achievement = achievement
    }

    @available(OSX 10.10, *)
    public init(identifier: String?, player: GKPlayer? = nil) {
        if let player = player {
            _achievement = GKAchievement(identifier: identifier, player: player)
        } else {
            _achievement = GKAchievement(identifier: identifier)
        }
    }

    /// Sends a report to the server updating the completion of the achievement.
    /// This method should only be called when `reportStatus` is `PendingReport`, but
    /// will not throw an error if it is not.
    /// - SeeAlso: `AchievementsManager.reportAllAchievements(_:completionHandler:)`
    public func report(completionHandler: ((NSError?) -> Void)?) {
        reportStatus = .Reporting

        GKAchievement.reportAchievements([_achievement]) { [weak self] (error) in
            guard let `self` = self else { return }

            self.reportCompleteWithError(error)

            completionHandler?(error)
        }
    }

    /// An internal method that must be called when the achievement
    /// is reported to the server. Is also used by `AchievementsManager`
    internal func reportCompleteWithError(error: NSError?) {
        if error != nil {
            self.reportStatus = .PendingReport
        } else if self.reportStatus != .PendingReport {
            // Only set the status to "not pending" if the current
            // status isn't "report required". This is because it is possible
            // to update the `percentComplete` while the report is being complete
            self.reportStatus = .NotPending
        }
    }
}

/// The status of whether or not a report is required
/// for an achievement
public enum AchievementReportStatus {
    /// Indicates that no local changes have been made
    /// that require reporting
    case NotPending

    /// Indicated that a local change has been made
    /// that needs to be reported to the server
    case PendingReport

    /// Indicates that the achievement is being reported
    /// to the server
    case Reporting
}
