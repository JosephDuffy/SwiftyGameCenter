#SwiftyGameCenter

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

##Features

- [x] Support for iOS, OS X, and tvOS
- [x] Local caches of data
- [x] Convenience methods and functions to make development faster

Mappings for:

- [x] Achievements
- [x] Achievement Descriptions
- [ ] Leaderboards
- [ ] Challenges
- [ ] Matches

##Usage

SwiftyGameCenter aims to be easy to use and cut down on the code required to implement Game Center in to your app. By default, SwiftyGameCenter will automatically load data when the user is authenticated. A simple setup would be:

```
SwiftyGameCenter.Manager.sharedInstance.authenticateLocalPlayer { (error) in
    if let error = error {
        if case .NotAuthenticated(let viewController) = error {
            // Present view controller
        }
    }
}
```

Note that the completion handler is called after authentication, not when the achievements are loaded.

###Achievements

Once achievements are loaded, they can be accessed via the `AchievementsManager` object.

```
let achievement = SwiftyGameCenter.AchievementsManager.sharedInstance.achievementWithIdentifier("AchievementIdentifier")
achievement.percentComplete = 70
achievement.report(nil)
```

Achievements can also be reported via the AchievementsManager, which will report all achievements with pending changes.

`SwiftyGameCenter.AchievementsManager.sharedInstance.reportAllAchievements(completionHandler: nil)`

##Installation

###Carthage

To install via [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

`github "JosephDuffy/SwiftyGameCenter"`

You will also need to add `GameKit` to the Linked Frameworks and Libraries.

###CocoaPods

To install via [CocoaPods](https://cocoapods.org/), specify it in your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'SwiftyGameCenter'
```