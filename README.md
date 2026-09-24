# Brew Coffee

Premium Flutter Web portfolio app — coffee customization, simulated espresso machine, and receipt-style ordering.

**Tagline:** Your coffee. Your way.

## Features

- Premium home, catalogue, and customization flows
- **MAKE MY COFFEE** → multi-phase drink machine simulation with cup visuals
- Receipt-style cart, checkout, order confirmation (print animation), tracking, and history
- BLoC/Cubit state management, repository pattern (mock + local persistence)
- Responsive layout (two-column customization on desktop)

## Architecture

```
lib/
├── app/           # MaterialApp, DI, router wiring
├── core/          # theme, routing, receipt widgets
├── data/          # mock catalog, local order storage
├── domain/        # entities, repositories, PricingService
└── features/      # home, catalog, customization, machine, cart, checkout, orders
```

## Run locally

```bash
cd brew_coffee
flutter pub get
flutter run -d chrome
```

## Build for GitHub Pages

```bash
flutter build web --base-href "/<your-repo-name>/"
```

Deploy the contents of `build/web` to your Pages branch or `gh-pages`.

Path URL strategy is enabled in `main.dart` for clean deep links.

## Tests

```bash
flutter test
```

Covers pricing, cart totals, coffee machine completion, and a basic home smoke test.

## Screenshots

Add GIFs of the machine simulation and receipt print animation under `docs/screenshots/` when capturing demos.

## License

Portfolio / demonstration project.
