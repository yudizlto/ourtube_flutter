# User Model Documentation

## Description

`UserModel` represents a user in the application. This model is used to store and manage user-related data, which is synchronized with Firestore.

---

## Firestore Structure

### Collection: `users`

Each user is stored as a document in the `users` collection.

#### Document Fields

| Field            | Type           | Description                                     |
| ---------------- | -------------- | ----------------------------------------------- |
| `userId`         | `String`       | Unique identifier for the user.                 |
| `displayName`    | `String`       | User's display name.                            |
| `username`       | `String`       | User's unique username.                         |
| `email`          | `String`       | User's email address.                           |
| `photoUrl`       | `String`       | URL of the user's profile picture.              |
| `subscriptions`  | `List<String>` | List of userIds that the user subscribes to.    |
| `videos`         | `List<String>` | List of video IDs uploaded by the user.         |
| `description`    | `String`       | User's bio or profile description.              |
| `type`           | `String`       | User type (e.g., "user", "admin").              |
| `createdAt`      | `DateTime`     | The date and time when the account was created. |
| `likedVideos`    | `List<String>` | List of video IDs that the user liked.          |
| `dislikedVideos` | `List<String>` | List of video IDs that the user disliked.       |

---
