import UIKit
import StyleSheet

enum TabBarItemId: Int {
    case feed
    case search
    case create
    case chat
    case userProfile
}

struct TabBarItem: Equatable {
    var id: TabBarItemId
    var viewController: UIViewController
    var uiTabBarItem: UITabBarItem {
        UITabBarItem(title: nil, image: icon, tag: id.rawValue)
    }

    var icon: UIImage? {
        switch id {
        case .feed: return UIImage(namedInStyleSheet: "tab.bar.feed")
        case .search: return UIImage(namedInStyleSheet: "tab.bar.search")
        case .create:
            return UIImage(namedInStyleSheet: "tab.bar.create")
//            let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
//            return image?.withBaselineOffset(fromBottom: 30)
        case .chat: return UIImage(namedInStyleSheet: "tab.bar.chat")
        case .userProfile: return UIImage(namedInStyleSheet: "tab.bar.profile")
        }
    }

    var accessibilityIdentifier: String {
        switch id {
        case .feed: return "StoryFeed"
        case .search: return "Search"
        case .create: return "CreateStory"
        case .chat: return "Chat"
        case .userProfile: return "UserProfile"
        }
    }
}
