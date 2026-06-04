# Wishing Well

This workspace mirrors the linked `Agiu/WishingWell-App` Swift Playgrounds package style while organizing the app like a maintainable SwiftUI iOS project.

## Structure

- `WishingWell.swiftpm/Package.swift`: Swift Playgrounds iOS app manifest.
- `Sources/AppModule/WishingWellApp.swift`: app entry point.
- `Sources/AppModule/RootView.swift`: onboarding gate and two-tab shell.
- `Sources/AppModule/Navigation`: tab and route definitions.
- `Sources/AppModule/Design`: shared color and typography tokens.
- `Sources/AppModule/Shared/Components`: reusable SwiftUI building blocks.
- `Sources/AppModule/Features`: feature-owned screens for onboarding, My Well, Feed, Ripples, and Settings.
- `Sources/AppModule/Models`: app models and preview fixtures.

## Notes

The manifest imports `AppleProductTypes`, matching the source repository. That module is provided by Swift Playgrounds/Xcode's app package flow, but it is not available to plain `swift build` in this local shell.

The bottom navigation is intentionally limited to `My Well` and `Feed`. Ripples opens from the top-right water icon, and Settings opens from the top-right hamburger icon as a trailing sidebar.

## Implemented Flows

- My Wishing Well: tap the manifestation entry card, write freeform text or start from a prompt, choose visibility, submit, see a confirmation, then jump to Feed.
- Feed: browse friend and shared manifestations, open a post detail, tap Comment, write an affirming response, submit, and see a confirmation.
