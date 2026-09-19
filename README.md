# 🎬 CINEMAX

CINEMAX is a modern Flutter movie application that provides a complete movie-browsing experience
powered by **The Movie Database (TMDB) API**, with Firebase authentication, wishlist
synchronization, movie search, movie details, social sharing, profile preferences, and an AI-powered
movie assistant using Google Gemini.

---

## ✨ Features

### 🔐 Authentication

- User registration with Firebase Authentication.
- Email verification.
- Login and logout.
- Google Sign-In.
- Password reset flow.
- Change password with current-password reauthentication.
- Automatic login for authenticated users.
- Form validation and user-friendly error handling.

### 🏠 Home

- Featured movies.
- Most popular movies.
- Movie categories.
- Genre-based movie filtering.
- Recommended movies.
- Pull-to-refresh.
- Real-time movie data from TMDB instead of static mock data.

### 🔎 Search

- Search for movies by title.
- Search for actors.
- Display movies associated with searched actors.
- Debounced search requests.
- Movie/Actor search filter.

### 🎥 Movie Details

- Movie poster and backdrop.
- Release year.
- Runtime.
- Certification.
- Genre.
- TMDB rating.
- Storyline/overview.
- Cast and crew.
- Real movie details fetched from TMDB.
- Add/remove movies from the wishlist.

### ❤️ Wishlist

- Start with an empty wishlist.
- Add movies to the user's wishlist.
- Remove movies from the wishlist.
- Store wishlist movies in Firestore.
- Keep wishlist state synchronized with the UI.

### 📤 Movie Sharing

Movie details can be shared through:

- Facebook
- WhatsApp
- Messenger
- Telegram

### 👤 Profile

- Edit username.
- Prevent duplicate usernames.
- Change password.
- Change preferred language.
- Change country.
- Logout.
- TMDB language/country preferences are applied to API requests.

### 🤖 CINEMAX AI

CINEMAX includes an AI movie assistant powered by Google Gemini.

The assistant can help with:

- Movies.
- Actors and actresses.
- Directors and writers.
- Movie characters.
- Movie plots and endings.
- Genres and franchises.
- Movie recommendations.
- Movie ratings.
- Cinema-related questions.
- Movie and documentary information.

The AI is instructed to stay within the movie/cinema domain and reject unrelated questions.

The architecture is designed to combine Gemini's conversational capabilities with the application's
real TMDB movie data.



---

## 🏗️ Architecture

The project follows a layered architecture inspired by **Clean Architecture**.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── database/
│   ├── network/
│   ├── validators/
│   └── widgets/
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── view/
│   │
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── view/
│   │
│   ├── movies/
│   │   ├── data/
│   │   ├── domain/
│   │   └── view/
│   │
│   ├── search/
│   │   ├── data/
│   │   ├── domain/
│   │   └── view/
│   │
│   ├── movie_details/
│   │   └── view/
│   │
│   ├── wishlist/
│   │   └── view/
│   │
│   ├── profile/
│   │   └── view/
│   │
│   └── ai_chat/
│       ├── data/
│       ├── domain/
│       └── view/
│
└── main.dart
```

### Main Layers

**Presentation**

- Flutter screens and widgets.
- UI state handling.
- Provider-based state management.

**Domain**

- Entities.
- Repositories.
- Use cases.

**Data**

- API data sources.
- Firebase data sources.
- Models.
- Repository implementations.

**Core**

- API client.
- API constants.
- Database manager.
- Shared widgets.
- Validators.
- Application-wide utilities.

---

## 🌐 APIs & Services

### TMDB API

CINEMAX uses TMDB as the primary movie data provider.

Used for:

- Popular movies.
- Discover movies.
- Movie search.
- Actor search.
- Movie details.
- Movie release dates.
- Movie credits.
- Actor movie credits.
- Movie images.

The application uses a centralized `ApiClient` built with Dio.

TMDB preferences such as language and country are applied through the application's preference
layer.

### Firebase

Firebase is used for:

- Authentication.
- Google Sign-In integration.
- Firestore.
- User profile data.
- Wishlist persistence.

### Google Gemini

Gemini powers the CINEMAX AI movie assistant.

The application communicates with Gemini through a dedicated remote data source using Dio and
maintains conversation context with interaction IDs.

---

## 🛠️ Tech Stack

| Technology              | Usage                        |
|-------------------------|------------------------------|
| Flutter                 | Mobile application framework |
| Dart                    | Programming language         |
| TMDB API                | Movie and actor data         |
| Firebase Authentication | User authentication          |
| Cloud Firestore         | User data and wishlist       |
| Google Sign-In          | Social authentication        |
| Google Gemini           | AI movie assistant           |
| Dio                     | HTTP networking              |
| Provider                | State management             |
| flutter_bloc            | BLoC/Cubit support           |
| Clean Architecture      | Project architecture         |
| MVVM principles         | Presentation organization    |
| dotenv                  | Environment variables        |

---

## 🎥 App Demo

https://github.com/user-attachments/assets/c2075663-e776-44a6-ae90-dc0aa92bf48b
