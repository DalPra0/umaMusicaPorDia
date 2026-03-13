//
//  musicaDoDiaWidgetLiveActivity.swift
//  musicaDoDiaWidget
//
//  Created by Lucas Dal Pra Brascher on 13/03/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct musicaDoDiaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct musicaDoDiaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: musicaDoDiaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension musicaDoDiaWidgetAttributes {
    fileprivate static var preview: musicaDoDiaWidgetAttributes {
        musicaDoDiaWidgetAttributes(name: "World")
    }
}

extension musicaDoDiaWidgetAttributes.ContentState {
    fileprivate static var smiley: musicaDoDiaWidgetAttributes.ContentState {
        musicaDoDiaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: musicaDoDiaWidgetAttributes.ContentState {
         musicaDoDiaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: musicaDoDiaWidgetAttributes.preview) {
   musicaDoDiaWidgetLiveActivity()
} contentStates: {
    musicaDoDiaWidgetAttributes.ContentState.smiley
    musicaDoDiaWidgetAttributes.ContentState.starEyes
}
