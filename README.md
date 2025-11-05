# ACC — Accounting Companion 💼

ACC is an offline-first personal finance companion crafted with Flutter, built on the principles of **simplification** and **minimalization**. The app strips away complexity, letting you capture transactions in the moment with just one hand via the home screen widget—no need to unlock, navigate, or fill in detailed forms. Tag categorization and notes can wait until you actually have time to open the app. It keeps your day-to-day spending organised, spotlights balances at a glance, and can mirror the ledger into Notion for shared visibility.

## Why You'll Like It ✨
- **One-handed quick capture** — The home widget lets you log an expense instantly with just your thumb, no unlocking or multi-step forms required.
- **Delay the details** — Skip categories and notes in the moment; add them later when you open the app and have time to reflect.
- **Offline-first peace of mind** — Your data lives locally, so the app feels instant and works anywhere.
- **At-a-glance insights** — Glimpse net balance the moment you land on the dashboard.
- **Optional cloud sync** — Link to a Notion database to mirror your ledger across devices and share with trusted contacts.
- **Clean architecture** — Modular design keeps state, data, and services neatly separated for easy maintenance and testing.

## How Things Fit Together 🧩
- **App shell** wires together theming, navigation, and dependency injection so screens load with the right data sources.
- **Model layer** describes what a transaction looks like, including metadata for future synchronisation.
- **State providers** expose observable account totals and sync status to the UI.
- **Repositories** wrap on-device persistence so the rest of the app can stay storage-agnostic.
- **Services** coordinate external integrations such as the Notion workspace and connectivity checks.
- **Platform hooks** enable the optional Android home widget to feed quick entries into the local ledger.

## Data & Backup Overview 🔄
- Transactions live in a local database so the app feels instant, even without connectivity.
- When a Notion workspace is connected, uploads keep the remote view aligned with the latest local changes.
- A lightweight status banner keeps you informed about sync progress, successes, or issues.

> ⚠️ Warning: Notion currently provides a view-only backup. Please do not edit transactions directly in Notion — two-way sync (remote edits back to the app) has not been implemented yet.

## Quick Start 🚀
1. Install Flutter 3.24 or newer plus your preferred device tooling.
2. Run `flutter pub get` to fetch project dependencies.
3. Create a `.env` file with your Notion integration token and database ID, then restart the app so the credentials load.
4. Launch the experience with `flutter run` and explore the dashboard, add transaction flow, and sync control.

## Roadmap Ideas 🗺️
- Smarter conflict handling and bidirectional Notion sync.
- Personalised categories, currencies, and localisation support.
- Home widget support beyond Android and richer quick-entry actions.
- remote(Notion) edits and resolving conflicts automatically.

---

Curious about extending the app or integrating new services? Open an issue or start a discussion — contributions are welcome! 🙌

