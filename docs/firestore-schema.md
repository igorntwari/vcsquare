# Firestore schema

How vsquare's data is stored in Cloud Firestore (project `vcsquared-131f0`).

This doc is the source of truth. If you change a collection or field, update these too, in the same PR:

| What | Where |
| --- | --- |
| Model read/write | `fromFirestore` / `toFirestore` in [`lib/data/models/`](../lib/data/models/) |
| Collection names | [`lib/data/repositories/firebase/firestore_collections.dart`](../lib/data/repositories/firebase/firestore_collections.dart) |
| Who can read/write | [`firestore.rules`](../firestore.rules) |
| Query indexes | [`firestore.indexes.json`](../firestore.indexes.json) |
| Seeded fixed data | [`tool/seed/data/`](../tool/seed/data/) |

## Conventions

- **Ids:** documents are referenced by id, never copied. For example, a post stores `authorId`, and the app looks up `users/{authorId}`. The one exception is `conversations.lastMessage`, which is copied so the inbox needs one read per row.
- **Dates:** Firestore `Timestamp`.
- **Money:** whole Rwandan francs as an integer (`priceRwf: 750000`).
- **Enums:** stored as their Dart name (`"likeNew"`, `"official"`).
- **Icons:** stored as a name string (`"laptop"`), looked up in [`AppIcons`](../lib/core/constants/app_icons.dart). Add the name there before using it in data.
- **Images:** `imagePath` / `avatarPath` hold either a bundled `assets/...` path (sample data) or an `https://` Firebase Storage download URL. [`AppImage`](../lib/shared/widgets/media/app_image.dart) handles both.
- **Per-user state:** likes, saves, follows and memberships live under `users/{uid}/…` as one empty-ish document per item. That keeps them private to the user and easy to add or remove.
- **Display order:** fixed lists have an `order` int, lowest first.

## Overview

```
users/{uid}
  ├─ likedPosts/{postId}
  ├─ savedListings/{listingId}
  ├─ memberships/{communityOrClubId}
  ├─ following/{officialHandleOrUserId}
  └─ peerSuggestions/{otherUid}
posts/{postId}
listings/{listingId}
conversations/{conversationId}
  └─ messages/{messageId}
communities/{communityId}          fixed, seeded
officialHandles/{handleId}         fixed, seeded
categories/{categoryId}            fixed, seeded
pickupHubs/{hubId}                 fixed, seeded
trendingTopics/{autoId}            written by the backend
```

## users/{uid}

One document per account: students, campus offices (`type: "official"`) and clubs (`type: "club"`). The id is the Firebase Auth uid for people who sign in. It holds both `UserModel` (public card) and `ProfileModel` (profile page) fields.

| Field | Type | Notes |
| --- | --- | --- |
| `name` | string | |
| `handle` | string | e.g. `"@amara.builds"` |
| `type` | string | `student` \| `official` \| `club` |
| `avatarPath` | string? | asset path or Storage URL |
| `cohort` | string? | students only, e.g. `"ALU '26"` |
| `isVerified` | bool | set by the backend |
| `isOnline` | bool | |
| `email` | string | written on first sign-in |
| `createdAt` | timestamp | written on first sign-in |
| `emailDomain` | string | profile, e.g. `"@alustudent.com"` |
| `roleTag` | string | profile, e.g. `"Student Leader • Year 3"` |
| `campus` | string | profile |
| `program` | string | profile, e.g. `"BSc Software Engineering • Class of 2027"` |
| `bio` | string | profile |
| `bioHighlight` | string? | part of `bio` shown in bold |
| `followerCount` | int | set by the backend |
| `followingCount` | int | set by the backend |
| `recognitionTitle` | string | profile banner, set by the backend |
| `recognitionSubtitle` | string | profile banner, set by the backend |

**Rules:** any signed-in user can read. Users create their own document and can only update the editable profile fields. Counters and verification are backend-only.

### Per-user subcollections (owner-only)

Each document is `{ createdAt: timestamp }`. Only the id matters.

| Subcollection | Document id | Replaces the old model flag |
| --- | --- | --- |
| `likedPosts` | post id | `PostModel.isLiked` |
| `savedListings` | listing id | `ListingModel.isFavorited` |
| `memberships` | community id or club user id | `CommunityModel.isJoined`, `UserModel.isJoined` |
| `following` | official handle id or user id | `OfficialHandleModel.isFollowing` |
| `peerSuggestions` | suggested user's uid | backend-written. Fields: `program`, `focus`, `mutualCount` (int), `sharedInterest` |

`MessageModel.isMine` was replaced by `senderId`; compare it with the signed-in uid.

## posts/{postId}

| Field | Type | Notes |
| --- | --- | --- |
| `authorId` | string | → `users/{authorId}` |
| `createdAt` | timestamp | feed is newest first |
| `body` | string | |
| `title` | string? | bold lead-in |
| `topic` | string? | tag on pinned posts |
| `audience` | string? | e.g. `"Everyone"` |
| `imagePath` | string? | |
| `imageCaption` | string? | location pill on the photo |
| `likeCount` | int | includes everyone's likes; changed by ±1 alongside `users/{uid}/likedPosts` in one transaction |
| `commentCount` | int | |
| `isPinned` | bool | Home shows pinned posts first |
| `isMandatoryRead` | bool | |
| `event` | map? | `{ title, startsAt: timestamp, venue, label?, note?, priceRwf?: int, showAsBanner: bool }` |
| `commentPreview` | map? | `{ authorId, text }` (latest comment) |

**Rules:** signed-in users read. The author creates (with counts at 0), edits content and deletes. Anyone signed in may change only `likeCount`, by exactly ±1.

**Index:** `authorId ASC, createdAt DESC` (Profile → My Posts).

## listings/{listingId}

| Field | Type | Notes |
| --- | --- | --- |
| `title` | string | max 80 chars in the form |
| `details` | string | spec line, e.g. `"8GB RAM • 256GB SSD"` |
| `priceRwf` | int | |
| `condition` | string | `brandNew` \| `likeNew` \| `good` \| `used` \| `forParts` |
| `categoryId` | string | → `categories/{id}` |
| `sellerId` | string | → `users/{sellerId}` |
| `createdAt` | timestamp | |
| `distanceKm` | number | placeholder until we compute distance from the buyer's pickup hub |
| `imagePath` | string? | Storage path `listings/{uid}/{listingId}/…` |
| `tag` | string? | label over the photo |
| `tagStyle` | string | `dark` \| `accent` \| `light` |

**Rules:** signed-in users read. Only the seller creates, updates (and can't change `sellerId`) or deletes.

**Index:** `sellerId ASC, createdAt DESC` (Profile → Listings).

## conversations/{conversationId}

| Field | Type | Notes |
| --- | --- | --- |
| `participantIds` | string[2] | both uids |
| `type` | string | `marketplace` \| `official` \| `peer` |
| `subject` | string? | bold topic line |
| `listingId` | string? | marketplace chats → `listings/{id}` |
| `lastMessage` | map | copy of the newest message: `{ text, sentAt, senderId, status }` |
| `updatedAt` | timestamp | = `lastMessage.sentAt`; inbox sort |
| `unreadCounts` | map<uid, int> | sender increments the other participant's count; opening the chat sets your own to 0 |

### conversations/{id}/messages/{messageId}

| Field | Type | Notes |
| --- | --- | --- |
| `text` | string | |
| `sentAt` | timestamp | chat is oldest first |
| `senderId` | string | must equal the writer's uid |
| `status` | string | `sent` \| `read` |

**Rules:** only participants read or write. Participants may update only `lastMessage`, `updatedAt` and `unreadCounts`. Messages can't be edited or deleted.

**Index:** `participantIds CONTAINS, updatedAt DESC` (inbox).

> `ChatsRepository` implements this. The Messages screens themselves are owned by another teammate and still read sample data.

## Fixed data (seeded, read-only in the app)

Written by [`tool/seed`](../tool/seed/seed.mjs) with the Admin SDK. The app can't write these.

### categories/{categoryId}
`name` string · `iconName` string · `order` int. Ids: `electronics`, `furniture`, `appliances`, `books`, `clothing`, `housing`, `services`, `other`.

### pickupHubs/{hubId}
`name` string · `description` string · `iconName` string · `order` int.

### officialHandles/{handleId}
`name` · `handle` · `category` (tag text, e.g. `"CAREERS"`) · `description` · `iconName` · `order`.

### communities/{communityId}
`name` · `tag` · `description` · `memberCount` int · `activity` (status line) · `memberPreviewIds` string[] (a few uids for the avatar pile) · `imagePath` string? · `order` int.

`memberCount` isn't updated when someone joins yet. That needs a Cloud Function on `users/{uid}/memberships`.

### trendingTopics/{autoId}
`tag` (with `#`) · `activity` (e.g. `"1.4k talks"`) · `rank` int, lowest first. Meant to be written by a backend job; not seeded.

## Storage paths

See [`storage.rules`](../storage.rules). Each user writes only their own folder, images only, under 5 MB:

- `avatars/{uid}/…`
- `listings/{uid}/{listingId}/…`
- `posts/{uid}/{postId}/…`

## Not built yet

- Cloud Functions for the counters (`followerCount`, `followingCount`, `memberCount`), `peerSuggestions` and `trendingTopics`.
- Comments as a `posts/{id}/comments` subcollection. Today only `commentPreview` and `commentCount` exist.
- Notifications are stored on the device only (see `NotificationService`), not in Firestore.
