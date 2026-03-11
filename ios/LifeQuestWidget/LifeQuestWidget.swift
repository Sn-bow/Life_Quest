import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CharacterEntry {
        CharacterEntry(date: Date(), name: "용사", level: 1, hp: 100)
    }

    func getSnapshot(in context: Context, completion: @escaping (CharacterEntry) -> ()) {
        let entry = CharacterEntry(date: Date(), name: "용사", level: 1, hp: 100)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // AppGroup Data Reading
        let appGroupId = Bundle.main.object(forInfoDictionaryKey: "HomeWidgetAppGroupId") as? String
            ?? "group.com.example.lifeQuestWidget"
        let userDefaults = UserDefaults(suiteName: appGroupId)
        
        let name = userDefaults?.string(forKey: "characterName") ?? "용사"
        let level = userDefaults?.integer(forKey: "characterLevel") ?? 1
        let hp = userDefaults?.integer(forKey: "characterHp") ?? 100

        let entry = CharacterEntry(date: Date(), name: name, level: level, hp: hp)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct CharacterEntry: TimelineEntry {
    let date: Date
    let name: String
    let level: Int
    let hp: Int
}

struct LifeQuestWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.name) (Lv.\(entry.level))")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
            Spacer().frame(height: 4)
            Text("HP: \(entry.hp)")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(red: 27/255, green: 29/255, blue: 40/255)) // Dark Theme color
    }
}

@main
struct LifeQuestWidget: Widget {
    let kind: String = "LifeQuestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LifeQuestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("라이프 퀘스트")
        .description("캐릭터의 현재 상태를 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
