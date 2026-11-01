import AppIntents
import Foundation

/// Shortcuts offered to Siri and Spotlight on install; phrases are localized in `AppShortcuts.strings`.
/// Gated at iOS 17 because `PerformActionAppIntent` and `GetCameraSnapshotAppIntent` are.
///
/// Every shortcut that names an entity carries a `parameterPresentation`, which labels it in the
/// Shortcuts app and in Siri.
///
/// **`systemImageName` is what tells the Spotlight rows apart, so no two may repeat.** The system
/// builds one row per shortcut per entity and titles every one of them with the entity's own name —
/// searching for a light returns a column all reading "Chamber light" — and the title cannot be
/// changed without the verb following the entity into Siri's disambiguation and the Shortcuts picker,
/// which reads as noise. The glyph has no such cost: the system draws the entity's own image where
/// its display representation sets one and falls back to the symbol here where it does not, so the
/// command entity types deliberately set none and these symbols reach the row instead. The cover pair
/// shows the shape of it — an open curtain against a closed one — and `HomeAssistantAppShortcutsTests`
/// pins every symbol as real and distinct.
@available(iOS 17.0, *)
struct HomeAssistantAppShortcuts: AppShortcutsProvider {
    static let shortcutTileColor: ShortcutTileColor = .lightBlue

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TurnOnOffEntityAppIntent(action: .on),
            phrases: [
                "\(.applicationName) turn on \(\.$entity)",
                "Turn on \(\.$entity) in \(.applicationName)",
                "Turn something on in \(.applicationName)",
            ],
            shortTitle: "Turn On",
            systemImageName: "lightswitch.on.fill",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Turn on \(\.$entity)"),
                optionsCollections: {
                    OptionsCollection(
                        ControllableEntityAppEntityQuery(),
                        title: "Entity",
                        systemImageName: "lightswitch.on.fill"
                    )
                }
            )
        )
        AppShortcut(
            intent: TurnOnOffEntityAppIntent(action: .off),
            phrases: [
                "\(.applicationName) turn off \(\.$entity)",
                "Turn off \(\.$entity) in \(.applicationName)",
                "Turn something off in \(.applicationName)",
            ],
            shortTitle: "Turn Off",
            systemImageName: "lightswitch.off.fill",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Turn off \(\.$entity)"),
                optionsCollections: {
                    OptionsCollection(
                        ControllableEntityAppEntityQuery(),
                        title: "Entity",
                        systemImageName: "lightswitch.off.fill"
                    )
                }
            )
        )
        AppShortcut(
            intent: GetEntityStateAppIntent(),
            phrases: [
                "\(.applicationName) is \(\.$entity) on",
                "Check an entity in \(.applicationName)",
                "Get an entity state from \(.applicationName)",
                "Is \(\.$entity) on in \(.applicationName)",
                "What is the state of \(\.$entity) in \(.applicationName)",
            ],
            shortTitle: "Get Entity State",
            systemImageName: "info.circle",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Is \(\.$entity) on"),
                optionsCollections: {
                    OptionsCollection(
                        ReadableEntityAppEntityQuery(),
                        title: "Entity",
                        systemImageName: "info.circle"
                    )
                }
            )
        )
        // The same thing tapping a Spotlight result does: open the entity's more-info dialog. "Open"
        // alone belongs to the cover shortcut below, so the phrases lead with "show" and spell out
        // "details" where they use the verb, rather than leaving Siri two readings of "open the blind".
        // The summary spells it out for the same reason: it is the one row that opens the app rather
        // than changing anything, and next to "Open <cover>" that has to be legible at a glance.
        AppShortcut(
            intent: ShowEntityDetailsAppIntent(),
            phrases: [
                "\(.applicationName) show \(\.$target)",
                "Show \(\.$target) in \(.applicationName)",
                "Open \(\.$target) details in \(.applicationName)",
                "Show something in \(.applicationName)",
            ],
            shortTitle: "Show Entity",
            systemImageName: "arrow.up.forward.app",
            parameterPresentation: ParameterPresentation(
                for: \.$target,
                summary: Summary("Open \(\.$target) details"),
                optionsCollections: {
                    OptionsCollection(
                        ReadableEntityOptionsProvider(),
                        title: "Entity",
                        systemImageName: "arrow.up.forward.app"
                    )
                }
            )
        )
        AppShortcut(
            intent: SetTemperatureAppIntent(),
            phrases: [
                "\(.applicationName) set a temperature",
                "Set a temperature in \(.applicationName)",
                "Set \(\.$entity) temperature in \(.applicationName)",
            ],
            shortTitle: "Set Temperature",
            systemImageName: "thermometer",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Set \(\.$entity) temperature"),
                optionsCollections: {
                    OptionsCollection(
                        ThermostatAppEntityQuery(),
                        title: "Thermostat",
                        systemImageName: "thermometer"
                    )
                }
            )
        )
        AppShortcut(
            intent: SetBrightnessAppIntent(),
            phrases: [
                "\(.applicationName) dim \(\.$light)",
                "Set a brightness in \(.applicationName)",
                "Dim \(\.$light) in \(.applicationName)",
            ],
            shortTitle: "Set Brightness",
            systemImageName: "sun.max",
            parameterPresentation: ParameterPresentation(
                for: \.$light,
                summary: Summary("Dim \(\.$light)"),
                optionsCollections: {
                    OptionsCollection(
                        DimmableLightAppEntityQuery(),
                        title: "Light",
                        systemImageName: "sun.max"
                    )
                }
            )
        )
        // Open and close are two shortcuts rather than one with the verb as a parameter: a phrase
        // may interpolate only a single parameter, and the entity is the one worth naming out loud.
        AppShortcut(
            intent: OpenCloseEntityAppIntent(action: .open),
            phrases: [
                "\(.applicationName) open \(\.$entity)",
                "Open \(\.$entity) in \(.applicationName)",
                "Open something in \(.applicationName)",
            ],
            shortTitle: "Open",
            systemImageName: "curtains.open",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Open \(\.$entity)"),
                optionsCollections: {
                    OptionsCollection(
                        OpenableEntityAppEntityQuery(),
                        title: "Cover",
                        systemImageName: "curtains.open"
                    )
                }
            )
        )
        AppShortcut(
            intent: OpenCloseEntityAppIntent(action: .close),
            phrases: [
                "\(.applicationName) close \(\.$entity)",
                "Close \(\.$entity) in \(.applicationName)",
                "Close something in \(.applicationName)",
            ],
            shortTitle: "Close",
            systemImageName: "curtains.closed",
            parameterPresentation: ParameterPresentation(
                for: \.$entity,
                summary: Summary("Close \(\.$entity)"),
                optionsCollections: {
                    OptionsCollection(
                        OpenableEntityAppEntityQuery(),
                        title: "Cover",
                        systemImageName: "curtains.closed"
                    )
                }
            )
        )
    }
}
