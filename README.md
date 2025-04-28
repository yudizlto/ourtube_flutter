# 🎬 OurTube Flutter App

A simple YouTube clone app made with Flutter. Supports localization (l10n), Supabase, Firebase, and YouTube API integration.

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yudizlto/ourtube_flutter.git
cd ourtube_flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate localization files
```bash
flutter gen-l10n
```

### 4. Set up environment variables
Create a `.env` file in the root of your project and add your own keys:
```ini
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
API_KEY=your_youtube_api_key
API_BASE_URL=https://www.googleapis.com/youtube/v3
```

### 5. Firebase configuration
a. Add your `google-service.json` file to:
```bash
android/app/google-services.json
```
You can download this from your Firebase Console after setting up an Android app.

b. Generate firebase_option.dart
Use the Firebase CLI to auto-generate the configuration file:
```bash
flutterfire configure
```
This will generate `lib/core/domain/firebase/firebase_options.dart`.

#

## 🛠️ Tech Stack

Here's a breakdown of the technologies used in this project:

- **Flutter** – Main framework used to build the mobile app.
- **Riverpod** – For state management across the app.
- **Localization (l10n)** – Uses Flutter’s built-in internationalization support with `flutter gen-l10n`.
- **Supabase** – Used for video and image storage.
- **Firebase** – Used for:
  - Authentication (Email/Password, Google Sign-In, etc).
  - Firestore Database for storing user and app data.
- **YouTube Data API v3** – To fetch video data and interact with YouTube-like content.

#
## 📱 App Preview

A visual walkthrough of OurTube's main screens and user flows.

---

### Home Screens
![Image](https://github.com/user-attachments/assets/7871806c-0a8d-432e-905d-7d1d9e0e8531)

### Subscription Screen
A feed showing videos from channels the user has subscribed to.
#
![Image](https://github.com/user-attachments/assets/d3b8c8d2-8bb8-4191-b069-1915e4f819a1)

### Library Screen
Displays user's watch history, liked videos, and saved content.
#
![Image](https://github.com/user-attachments/assets/75c328a2-bb33-44a1-99ca-384ed16bbbae)

### My Channel
User profile page showing uploaded videos, channel banner, and info.
#
![Image](https://github.com/user-attachments/assets/77d3b1cf-e315-4bb2-b8b8-525c4f7ae0fc)

### Home Drawer & Categories
The home drawer includes quick access to various video categories, include:
- 🔥 Trending  
- 🎵 Music
- etc
#
![Image](https://github.com/user-attachments/assets/165b8ab6-06b9-436b-bcd3-7e5e69333225)

#
## 🎨 Icons Attribution

This project uses icons from [Flaticon](https://www.flaticon.com/) under the Flaticon Free License. These icons are free to use for personal and commercial purposes **with attribution**.

- [Content management icons](https://www.flaticon.com/free-icons/content-management) created by [Afian Rochmah Afif](https://www.flaticon.com/authors/afian-rochmah-afif) - Flaticon  
- [Cinema icons](https://www.flaticon.com/free-icons/cinema) created by [Freepik](https://www.flaticon.com/authors/freepik) - Flaticon  
- [Short video icons](https://www.flaticon.com/free-icons/short-video) created by [andinur](https://www.flaticon.com/authors/andinur) - Flaticon  
- [Video icons](https://www.flaticon.com/free-icons/video) created by [Freepik](https://www.flaticon.com/authors/freepik) - Flaticon  
- [Video icons](https://www.flaticon.com/free-icons/video) created by [smalllikeart](https://www.flaticon.com/authors/smalllikeart) - Flaticon  
- [Blog icons](https://www.flaticon.com/free-icons/blog) created by [Smashicons](https://www.flaticon.com/authors/smashicons) - Flaticon  
- [Subscription icons](https://www.flaticon.com/free-icons/subscription) created by [Freepik](https://www.flaticon.com/authors/freepik) - Flaticon  
- [Playlist icons](https://www.flaticon.com/free-icons/playlist) created by [surang](https://www.flaticon.com/authors/surang) - Flaticon  
- [Trophy icons](https://www.flaticon.com/free-icons/trophy) created by [Creative Stall Premium](https://www.flaticon.com/authors/creative-stall-premium) - Flaticon  
- [Game boy advance icons](https://www.flaticon.com/free-icons/game-boy-advance) created by [Freepik](https://www.flaticon.com/authors/freepik) - Flaticon  
- [Fire icons](https://www.flaticon.com/free-icons/fire) created by [Those Icons](https://www.flaticon.com/authors/those-icons) - Flaticon  
- [Compass icons](https://www.flaticon.com/free-icons/compass) created by [Those Icons](https://www.flaticon.com/authors/those-icons) - Flaticon  
- [Password icons](https://www.flaticon.com/free-icons/password) created by [Prosymbols Premium](https://www.flaticon.com/authors/prosymbols-premium) - Flaticon

#
### Download APK

You can download the OurTube APK from the link below:

- [Download APK (arm64-v8a)](https://drive.google.com/file/d/1RFb1hGCwyx7n7UpNRL_0x7s-O0j6Adyj/view?usp=sharing)
- [Download APK (armeabi-v7a)](https://drive.google.com/file/d/1ydj6JJU9b9NGhfQvBQyNxDtagg7R_jiH/view?usp=sharing)
