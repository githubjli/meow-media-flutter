# BACKEND_API_CONTRACT_SHORT_DRAMA

This document defines the backend API contract expected by the Flutter short-drama client.

## Global contract rules

- Authenticated endpoints use bearer token auth unless otherwise noted.
- All paid/spending actions should be idempotent on backend side.
- Flutter displays **Meow Points** for platform credits.
- Flutter displays **THB-LTT** only in payment/purchase contexts.
- Flutter does not hardcode exchange rates.
- Flutter reads and displays `exchange_rate_label` from backend responses.
- If Meow Points are insufficient during unlock/payment flows, Flutter should route user to `/meow-points`.

---

## A) Short drama APIs

### 1. GET `/api/dramas/`

- **Auth**: Optional (recommended authenticated for personalized flags)
- **Expected request**:
  - Query params (optional): `page`, `page_size`, `category`, `is_featured`, `ordering`
- **Expected response**:
  - List of drama series items (or paginated envelope), e.g. id, title, cover image, tags, total episodes, free episode count, is_favorited
- **Flutter display notes**:
  - Use response to render drama home feed.
  - Show free/locked hints from backend fields.
- **Error states**:
  - `400` invalid query params
  - `401` token invalid/expired (if endpoint enforced auth)
  - `500` server error

### 2. GET `/api/dramas/{id}/`

- **Auth**: Optional (recommended authenticated)
- **Expected request**:
  - Path: `id` (series id)
- **Expected response**:
  - Drama detail object: metadata, synopsis, counts, favorite flag, pricing summary fields
- **Flutter display notes**:
  - Drives drama detail header and series-level metadata.
- **Error states**:
  - `404` drama not found
  - `401` unauthorized (if auth required)
  - `500` server error

### 3. GET `/api/dramas/{id}/episodes/`

- **Auth**: Optional (recommended authenticated)
- **Expected request**:
  - Path: `id`
  - Query params (optional): `page`, `page_size`
- **Expected response**:
  - Episode list with lock/unlock/free state, episode number, title, thumbnail, duration, price_points
- **Flutter display notes**:
  - Locked episodes should display lock state + price in Meow Points.
- **Error states**:
  - `404` drama not found
  - `400` invalid pagination params
  - `500` server error

### 4. GET `/api/dramas/{id}/episodes/{episode_no}/`

- **Auth**: Optional (recommended authenticated)
- **Expected request**:
  - Path: `id`, `episode_no`
- **Expected response**:
  - Episode detail object including play metadata and user access fields (`is_free`, `is_unlocked`, `price_points`)
- **Flutter display notes**:
  - If locked and not unlocked, show unlock CTA with Meow Points pricing.
- **Error states**:
  - `404` episode not found
  - `500` server error

### 5. POST `/api/dramas/{id}/progress/`

- **Auth**: Required
- **Expected request**:
```json
{
  "episode_id": 101,
  "progress_seconds": 42,
  "duration_seconds": 120,
  "is_completed": false
}
```
- **Expected response**:
```json
{
  "saved": true,
  "series_id": 1,
  "episode_id": 101,
  "progress_seconds": 42,
  "updated_at": "2026-04-27T10:00:00Z"
}
```
- **Flutter display notes**:
  - Used for continue-watching shelves and resume behavior.
- **Error states**:
  - `400` invalid payload
  - `401` unauthorized
  - `404` series/episode not found

### 6. POST `/api/dramas/{id}/favorite/`

- **Auth**: Required
- **Expected request**:
  - Path: `id`
  - Empty body allowed
- **Expected response**:
```json
{
  "series_id": 1,
  "is_favorited": true
}
```
- **Flutter display notes**:
  - Optimistically update favorite icon, reconcile with response.
- **Error states**:
  - `401` unauthorized
  - `404` series not found
  - `409` already favorited (optional)

### 7. DELETE `/api/dramas/{id}/favorite/`

- **Auth**: Required
- **Expected request**:
  - Path: `id`
- **Expected response**:
```json
{
  "series_id": 1,
  "is_favorited": false
}
```
- **Flutter display notes**:
  - Remove from favorites and refresh favorite list if present.
- **Error states**:
  - `401` unauthorized
  - `404` series/favorite relation not found

### 8. GET `/api/account/drama-progress/`

- **Auth**: Required
- **Expected request**:
  - Query params (optional): `page`, `page_size`
- **Expected response**:
  - Continue-watching collection containing series, episode, and last progress snapshot
- **Flutter display notes**:
  - Render continue watching section on home/profile.
- **Error states**:
  - `401` unauthorized
  - `500` server error

### 9. GET `/api/account/drama-favorites/`

- **Auth**: Required
- **Expected request**:
  - Query params (optional): `page`, `page_size`
- **Expected response**:
  - Favorite drama list
- **Flutter display notes**:
  - Drives “Favorites” page/list.
- **Error states**:
  - `401` unauthorized
  - `500` server error

---

## B) Meow Points APIs

### 1. GET `/api/meow-points/me/`

- **Auth**: Required
- **Expected request**: none
- **Expected response**:
```json
{
  "balance": 1250,
  "display_name": "Meow Points",
  "unit": "points"
}
```
- **Flutter display notes**:
  - Always display `display_name` as Meow Points balance context.
- **Error states**:
  - `401` unauthorized
  - `500` server error

### 2. GET `/api/meow-points/packages/`

- **Auth**: Required
- **Expected request**:
  - Query params (optional): `active=true`
- **Expected response**:
```json
[
  {
    "id": 1,
    "name": "Starter Pack",
    "points_amount": 1000,
    "bonus_points": 0,
    "total_points": 1000,
    "payment_amount": "100.00",
    "payment_currency": "THB-LTT",
    "blockchain": "LTT",
    "token_name": "LTT Thai Baht Stablecoin",
    "exchange_rate": "10.00000000",
    "exchange_rate_label": "1 THB-LTT = 10 Meow Points"
  }
]
```
- **Flutter display notes**:
  - Display `total_points` as Meow Points.
  - Display `payment_amount` + `payment_currency` in purchase UI only.
  - Display `exchange_rate_label` directly.
- **Error states**:
  - `401` unauthorized
  - `500` server error

### 3. GET `/api/meow-points/transactions/`

- **Auth**: Required
- **Expected request**:
  - Query params (optional): `type`, `page`, `page_size`, `from`, `to`
- **Expected response**:
  - Transaction list including signed deltas and balance snapshots
- **Flutter display notes**:
  - Use Meow Points labels for all deltas and balances.
- **Error states**:
  - `400` invalid filters
  - `401` unauthorized

### 4. POST `/api/meow-points/purchase-orders/`

- **Auth**: Required
- **Expected request**:
```json
{
  "package_id": 1,
  "client_request_id": "b4b5718e-1451-4630-92d8-2f4bc0f2f080"
}
```
- **Expected response**:
```json
{
  "order_no": "MP20260427ABC123",
  "status": "pending",
  "total_points": 1000,
  "payment_amount": "100.00",
  "payment_currency": "THB-LTT",
  "blockchain": "LTT",
  "token_name": "LTT Thai Baht Stablecoin",
  "pay_to_address": "ltt...",
  "exchange_rate_snapshot": "10.00000000",
  "exchange_rate_label": "1 THB-LTT = 10 Meow Points",
  "expires_at": "2026-04-27T12:00:00Z"
}
```
- **Flutter display notes**:
  - Show payment info in THB-LTT context only.
  - Treat `client_request_id` as idempotency key.
- **Error states**:
  - `400` invalid package/request
  - `401` unauthorized
  - `409` duplicate client_request_id with conflicting payload

### 5. GET `/api/meow-points/purchase-orders/{order_no}/`

- **Auth**: Required
- **Expected request**:
  - Path: `order_no`
- **Expected response**:
  - Purchase order detail with current status (`pending`, `paid`, `expired`, `cancelled`)
- **Flutter display notes**:
  - Poll/reload status page and refresh Meow Points balance after `paid`.
- **Error states**:
  - `401` unauthorized
  - `404` order not found

---

## C) Episode unlock API

### POST `/api/episodes/{id}/unlock/`

- **Auth**: Required
- **Expected request**:
```json
{
  "client_request_id": "67a9e8fd-aa4f-4868-b8e8-dc8f624ce95e"
}
```
- **Expected response**:
```json
{
  "episode_id": 101,
  "is_unlocked": true,
  "spent_points": 30,
  "balance_after": 1220
}
```
- **Flutter display notes**:
  - Deduct visual balance only from response.
  - Navigate to `/meow-points` on insufficient points response.
- **Error states**:
  - `401` unauthorized
  - `402` insufficient Meow Points
  - `404` episode not found
  - `409` duplicate `client_request_id` should return same outcome if idempotent

---

## D) Membership exchange APIs

### 1. GET `/api/meow-points/membership-exchange-rules/`

- **Auth**: Required
- **Expected request**: none
- **Expected response**:
  - Available exchange tiers (e.g., points cost, membership days, labels, active flags)
- **Flutter display notes**:
  - Display values as Meow Points costs.
- **Error states**:
  - `401` unauthorized
  - `500` server error

### 2. POST `/api/meow-points/exchange-membership/`

- **Auth**: Required
- **Expected request**:
```json
{
  "rule_id": 2,
  "client_request_id": "b66e8cbd-2727-4f2e-b36a-898ee60295bc"
}
```
- **Expected response**:
```json
{
  "success": true,
  "membership_expires_at": "2026-07-26T00:00:00Z",
  "spent_points": 300,
  "balance_after": 920
}
```
- **Flutter display notes**:
  - Treat as spending action; show Meow Points spending details.
- **Error states**:
  - `401` unauthorized
  - `402` insufficient Meow Points
  - `404` rule not found
  - `409` duplicate client_request_id semantics same as unlock

---

## E) Live gifts APIs

### 1. GET `/api/live-gifts/`

- **Auth**: Required
- **Expected request**:
  - Query params (optional): `active=true`
- **Expected response**:
  - Gift catalog: id, name, icon, cost_points, animation_key, active
- **Flutter display notes**:
  - Display gift costs in Meow Points.
- **Error states**:
  - `401` unauthorized
  - `500` server error

### 2. POST `/api/live/{id}/gifts/`

- **Auth**: Required
- **Expected request**:
```json
{
  "gift_id": 9,
  "quantity": 1,
  "client_request_id": "d7775fd4-cf43-49f6-a6a8-3b6852ef1e80"
}
```
- **Expected response**:
```json
{
  "live_id": 88,
  "gift_id": 9,
  "quantity": 1,
  "spent_points": 20,
  "balance_after": 1200,
  "sent": true
}
```
- **Flutter display notes**:
  - Spending display remains Meow Points only.
- **Error states**:
  - `401` unauthorized
  - `402` insufficient Meow Points
  - `404` live room or gift not found
  - `409` duplicate client_request_id should be idempotent

---

## Common frontend assumptions (enforced)

1. Flutter displays **Meow Points** for credits.
2. Flutter displays **THB-LTT** only for payment.
3. Flutter does not hardcode exchange rates.
4. Flutter reads `exchange_rate_label` from backend.
5. Flutter handles insufficient balance by navigating to `/meow-points`.
6. Flutter handles locked episodes gracefully.
7. Flutter treats paid/spending actions as idempotent via `client_request_id`.
