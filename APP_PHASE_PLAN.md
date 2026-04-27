# APP_PHASE_PLAN

## 1) Product direction

This Flutter app will first evolve into a **short-drama mobile client** on top of the current clean foundation. The MVP direction focuses on:

- short-drama home
- drama detail
- vertical episode player (placeholder first)
- continue watching
- favorites
- locked/free episode presentation
- Meow Points wallet
- future THB-LTT purchase flow
- future membership exchange
- future live gifts

The sequencing is intentionally incremental so the project remains stable and easy to extend.

## 2) Current repository baseline

Current repository status:

- Flutter project
- Riverpod state-management foundation
- Dio networking foundation
- GoRouter navigation foundation

At this stage, the app is still a minimal shell/bootstrap structure and should be extended gradually with additive feature modules.

## 3) Naming agreement (must stay consistent)

- UI displays **Meow Points** for platform credit balances and spending.
- **THB-LTT** appears only in purchase/payment context.
- **LTT** is the blockchain.
- **THB-LTT** is the payment token symbol.
- **LTT Thai Baht Stablecoin** is the payment token name.
- **Meow Points** are internal platform credits.
- Exchange rate is backend-driven (Flutter must not hardcode it).

## 4) Flutter phase plan

### Phase 1 — Mock short-drama shell (no real backend/payment)

Build with local mock data only:

- drama home screen
- drama detail screen
- episode player placeholder (non-real player)
- Meow Points wallet placeholder
- profile placeholder
- no real payment
- no real backend integration

Planned routes:

- `/`
- `/dramas/:seriesId`
- `/dramas/:seriesId/episodes/:episodeNo`
- `/meow-points`
- `/profile`

### Phase 2 — Connect Django short-drama APIs

Integrate short-drama content/progress/favorite APIs:

- `GET /api/dramas/`
- `GET /api/dramas/{id}/`
- `GET /api/dramas/{id}/episodes/`
- `GET /api/dramas/{id}/episodes/{episode_no}/`
- `POST /api/dramas/{id}/progress/`
- `POST /api/dramas/{id}/favorite/`
- `DELETE /api/dramas/{id}/favorite/`
- `GET /api/account/drama-progress/`
- `GET /api/account/drama-favorites/`

### Phase 3 — Connect Meow Points + episode unlock flows

Integrate Meow Points and unlock contracts:

- `GET /api/meow-points/me/`
- `GET /api/meow-points/packages/`
- `GET /api/meow-points/transactions/`
- `POST /api/meow-points/purchase-orders/`
- `GET /api/meow-points/purchase-orders/{order_no}/`
- `POST /api/episodes/{id}/unlock/`

### Phase 4 — Membership exchange + live gifts

Integrate later extensions:

- `GET /api/meow-points/membership-exchange-rules/`
- `POST /api/meow-points/exchange-membership/`
- `GET /api/live-gifts/`
- `POST /api/live/{id}/gifts/`

## 5) Proposed Flutter structure (future target)

```text
lib/
  app/
    app.dart
    router.dart
    theme.dart
  core/
    config/
      app_config.dart
    network/
      api_client.dart
      auth_interceptor.dart
    storage/
      token_storage.dart
  features/
    drama/
      data/
        drama_models.dart
        drama_mock_data.dart
        drama_api.dart
      screens/
        drama_home_screen.dart
        drama_detail_screen.dart
        episode_player_screen.dart
      widgets/
        drama_card.dart
        episode_grid.dart
    meow_points/
      data/
        meow_point_models.dart
        meow_point_mock_data.dart
        meow_point_api.dart
      screens/
        meow_points_wallet_screen.dart
        meow_points_purchase_order_screen.dart
      widgets/
        meow_point_package_card.dart
    profile/
      screens/
        profile_screen.dart
```

## 6) UI behavior rules

- Use **Meow Points** in balance, unlock, membership, and gift contexts.
- Use **THB-LTT** only in package purchase/payment context.
- Locked episodes should show lock state and price in Meow Points.
- If user balance is insufficient, navigate to `/meow-points`.
- Package cards should display:
  - total Meow Points
  - payment amount in THB-LTT
  - `exchange_rate_label` returned by backend
- Flutter must not calculate exchange rate.
- Flutter must not assume `1 THB-LTT = 10 Meow Points` except inside mock data used in Phase 1.

## 7) Implementation guardrails

- Keep all changes minimal and additive.
- Avoid large refactors.
- Do not mix live-streaming implementation into short-drama MVP Phase 1.
- Do not implement real wallet payment before backend contract is finalized.
- Isolate mock data so it can be replaced by API data with minimal churn.
- Keep model names close to backend response names for easier integration.
