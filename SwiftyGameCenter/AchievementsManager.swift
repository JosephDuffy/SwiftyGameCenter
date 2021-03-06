//
//  AchievementsManager.swift
//  SwiftyGameCenter
//
//  Created by Joseph Duffy on 30/05/2016.
//  Copyright © 2016 Yetii Ltd. All rights reserved.
//

import Foundation
import GameKit

/// A singleton manager for Game Center achievements
public class AchievementsManager {
    /// The shared instance of the AchievementsManager object
    public static let sharedInstance = AchievementsManager()

    /// A flag that indicates if achievements are currently being loaded
    private(set) var loadingAchievements = false

    /// A private cache of the loaded achievements, indexed by identifier
    private(set) var achievementsCache: [String : Achievement] = [:]

    /// A flag that indicates if achievement descriptions are currently being loaded
    private(set) var loadingAchievementDescriptions = false

    /// A private cache of the loaded achievement descriptions, indexed by identifier
    private(set) var achievementDescriptionsCache: [String : AchievementDescription] = [:]

    /// Private init to ensure only 1 instance is created
    private init() {}

    /**
     Adds the provide achievement to the cache. This method can be used when
     an achievement is manually created. The provided achievement must have
     an identifier and must not already be in the cache
     
     - parameter achievement: The achievement to add to the cache
     
     - returns: `true` if added to the cache, otherwise `false`
    */
    public func addAchievementToCache(achievement: Achievement) -> Bool {
        guard let identifier = achievement.identifier else { return false }

        if achievementsCache[identifier] != nil {
            achievementsCache[identifier] = achievement

            return true
        } else {
            return false
        }
    }

    /**
     Loads the achievements from Game Center. Loading is performed in the background and
     the completion handler will be called from the main thread. Achievements without an
     identifier are ignored. This function will build the achievements cache that is used
     when retrieving achievements by identifier.
     
     - parameter completionHandler: The closure to call when the achievements are loaded.
     
     - SeeAlso: `GKAchievement.loadAchievementsWithCompletionHandler`
    */
    public func loadAchievements(completionHandler: (([Achievement]?, LoadAchievementsError?) -> Void)?) {
        guard !loadingAchievements else {
            completionHandler?(nil, LoadAchievementsError.AlreadyLoading)

            return
        }

        loadingAchievements = true
        achievementsCache = [:]

        GKAchievement.loadAchievementsWithCompletionHandler { [weak self] (achievements, error) in
            guard let `self` = self else { return }

            if let achievements = achievements {
                for achievement in achievements {
                    guard let identifier = achievement.identifier else { continue }

                    self.achievementsCache[identifier] = Achievement(achievement: achievement)
                }
            }

            let loadedAchievments = Array(self.achievementsCache.values)

            let errorWrapper: LoadAchievementsError? = {
                if let error = error {
                    return LoadAchievementsError.GameCenterError(underlyingError: error)
                } else {
                    return nil
                }
            }()

            self.loadingAchievements = false

            completionHandler?(loadedAchievments, errorWrapper)
        }
    }

    /**
     Loads the achievement descriptions from Game Center. Loading is performed in the background and
     the completion handler will be called from the main thread. Descriptions without an
     identifier are ignored. This function will build the achievement descriptions cache that is used
     when retrieving achievement descriptions by identifier.

     - parameter completionHandler: The closure to call when the descriptions are loaded.

     - SeeAlso: `GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler`
     */
    public func loadAchievementDescriptions(completionHandler: (([AchievementDescription]?, LoadAchievementsError?) -> Void)?) {
        guard !loadingAchievementDescriptions else {
            completionHandler?(nil, LoadAchievementsError.AlreadyLoading)

            return
        }

        loadingAchievementDescriptions = true
        achievementDescriptionsCache = [:]

        GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler { [weak self] (descriptions, error) in
            guard let `self` = self else { return }

            if let descriptions = descriptions {
                for description in descriptions {
                    guard let identifier = description.identifier else { continue }

                    self.achievementDescriptionsCache[identifier] = AchievementDescription(achievementDescription: description)
                }
            }

            let loadedAchievmentDescriptionss = Array(self.achievementDescriptionsCache.values)

            let errorWrapper: LoadAchievementsError? = {
                if let error = error {
                    return LoadAchievementsError.GameCenterError(underlyingError: error)
                } else {
                    return nil
                }
            }()

            self.loadingAchievementDescriptions = false
            
            completionHandler?(loadedAchievmentDescriptionss, errorWrapper)
        }
    }

    /**
     Report all achievements to the server. By default will only send reports for
     achievements with pending changes.
     
      - parameter onlyIncludePending: If true, only achievement with pending changes will be submitted
      - parameter completionHandler:  The closure to call when the report is complete. A nil error indicates
                                      a successful report
    */
    public func reportAllAchievements(onlyIncludePending: Bool = true, completionHandler: ((NSError?) -> Void)?) {
        let achievements: [Achievement] = {
            let achievementsCacheArray = Array(achievementsCache.values)

            if onlyIncludePending {
                return achievementsCacheArray.filter({ (achievement: Achievement) -> Bool in
                    return achievement.reportStatus == .PendingReport
                })
            } else {
                return achievementsCacheArray
            }
        }()

        for achievement in achievements {
            achievement.reportStatus = .Reporting
        }

        let underlyingAchievements = achievements.map({ $0._achievement })

        GKAchievement.reportAchievements(underlyingAchievements) { (error) in
            for achievement in achievements {
                achievement.reportCompleteWithError(error)
            }

            completionHandler?(error)
        }
    }

    public func achievementWithIdentifier(identifier: String) -> Achievement? {
        return achievementsCache[identifier]
    }

    public subscript(identifier: String) -> Achievement? {
        return achievementsCache[identifier]
    }
}

public enum LoadAchievementsError: ErrorType {
    case AlreadyLoading
    case GameCenterError(underlyingError: NSError)
}
