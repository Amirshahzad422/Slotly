# Slotly — Modern In-Person Appointment Booking Platform

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Riverpod-blue)](https://riverpod.dev)
[![Typography](https://img.shields.io/badge/Typography-Outfit-purple)](https://fonts.google.com/specimen/Outfit)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Slotly** is an ultra-premium, production-grade Flutter web & mobile application designed for discovering and instantly booking in-person appointments at top-rated local venues (Salons, Gyms, Clinics, Spas, and Barber Lounges). Built with a state-of-the-art pastel-and-capsule design system, glassmorphic card overlays, fluid micro-animations, and responsive layout architecture.

---

## ✨ Key Features & User Flow

### 📱 Core Capabilities
- **In-Person Appointment Domain**: Populated with 12 curated venue services across 5 core categories (*Salon & Beauty*, *Gym & Fitness*, *Clinic & Health*, *Spa & Body*, *Barber Lounge*) and 5 top-rated verified venue providers.
- **Dynamic Search & Multi-Criteria Filtering**: Filter services by category, venue provider, minimum rating (up to 5.0★), price range ($0 – $500), and custom sorting options (Popularity, Price Low to High, Price High to Low, Highest Rated).
- **Interactive Multi-Tier Slot Picker**: Select appointment dates with interactive horizontal day pickers and choose available time slots (09:00 AM, 11:30 AM, 02:00 PM, 04:30 PM).
- **Service Tier Customization**: Switch between *Classic*, *Deluxe*, and *VIP Premium* service tiers with live price updates.
- **Appointment Management & Rescheduling**: View upcoming, completed, and cancelled bookings. Includes bottom-docked modal sheets for instant slot rescheduling and cancellation confirmation.
- **Favorites & Wishlist**: Toggle favorites on service cards with instant persistence across sessions.
- **Responsive Layout Engine**: Optimized layouts for mobile view (`width <= 600`), tablet view, and desktop web view (`maxWidth: 1100px`) with 3-column responsive grid cards.

### 🎨 UI/UX & Design Highlights
- **Typography System**: Powered by **Outfit** (via `google_fonts`), delivering crisp line heights, readable letter spacing, and luxury display headings.
- **Shimmer Pulse Loading**: Custom `ShimmerBox` and `ShimmerImage` placeholder skeletons for list cards, grid cards, and images.
- **Smart Floating Bottom Navbar**: Floating capsule nav bar that automatically slides down and hides on scroll-down, returning smoothly on scroll-up.
- **Pinned Top Headers**: Pinned top navigation headers and TabBars ensure zero unnecessary scrolling or title displacement.
- **Sticky Bottom Action Bars**: Sticky action containers on booking and confirmation screens with zero bottom whitespace.
- **Zero Scrollbars**: Clean, scrollbar-free scrolling experience configured globally via custom `NoScrollbarBehavior`.

---

## 🛠️ Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Web, iOS, Android, Desktop) |
| **Language** | [Dart](https://dart.dev) (Null Safety enabled) |
| **State Management** | [Flutter Riverpod](https://riverpod.dev) (`ConsumerWidget`, `StateNotifierProvider`, `StateProvider`) |
| **Typography** | [Google Fonts — Outfit](https://fonts.google.com/specimen/Outfit) |
| **URL Strategy** | `url_strategy` (Path URL strategy for clean Web URLs without hash tags) |
| **Testing** | Flutter Test framework |

---

## 📂 Project Architecture

```
Slotly/
├── lib/
│   ├── components/       # Reusable UI components & design system elements
│   │   ├── banner.dart         # Hero promo banner with glassmorphic cards
│   │   ├── bottom_nav.dart     # Floating capsule auto-hiding navbar
│   │   ├── button.dart         # Custom pill & primary buttons
│   │   ├── category_chip.dart  # Animated category selector chips
│   │   ├── filters.dart        # Bottom-docked filter sheet with rating/price controls
│   │   ├── header.dart         # Pinned top header with back button & profile pill
│   │   ├── loader.dart         # Shimmer skeleton loaders & ShimmerImage
│   │   ├── modal.dart          # Bottom-docked app modal sheet
│   │   ├── search_bar.dart     # Glassmorphic search bar with clear button
│   │   ├── service_card.dart   # Grid & List view cards with image placeholders
│   │   ├── slot_picker.dart    # Date & time slot picker widget
│   │   └── testimonials.dart  # Interactive venue review carousel
│   ├── data/             # Mock dataset for services & venue providers
│   │   └── mock_data.dart
│   ├── layouts/          # Responsive main layout wrapper
│   │   └── main_layout.dart
│   ├── models/           # Strongly-typed data models
│   │   ├── appointment_model.dart
│   │   ├── provider_model.dart
│   │   └── service_model.dart
│   ├── providers/        # Riverpod state management logic
│   │   ├── booking_provider.dart
│   │   ├── favorites_provider.dart
│   │   └── search_provider.dart
│   ├── screens/          # Application views
│   │   ├── about_screen.dart
│   │   ├── appointments_screen.dart
│   │   ├── blog_screen.dart
│   │   ├── booking_screen.dart
│   │   ├── confirm_screen.dart
│   │   ├── contact_screen.dart
│   │   ├── faq_screen.dart
│   │   ├── home_screen.dart
│   │   ├── not_found_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── provider_screen.dart
│   │   ├── selected_category_screen.dart
│   │   ├── service_details_screen.dart
│   │   └── services_screen.dart
│   ├── styles/           # Global color palette & design tokens
│   │   └── colors.dart
│   ├── utils/            # Helper utilities & currency/date formatters
│   │   └── formatters.dart
│   └── main.dart         # App entrypoint & MaterialApp configuration
├── test/                 # Automated widget & unit tests
│   └── widget_test.dart
├── pubspec.yaml          # Dependencies & project manifest
└── README.md             # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>=3.0.0`)

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/verxeon-ai/Slotly.git
   cd Slotly
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Web View)**:
   ```bash
   flutter run -d chrome --web-port=8080
   ```

4. **Run Automated Tests**:
   ```bash
   flutter test
   ```

5. **Perform Static Code Analysis**:
   ```bash
   flutter analyze
   ```

---

## 🧪 Verification & Quality Control

- **Static Analysis**: `flutter analyze` passes with **0 issues found**.
- **Widget Tests**: `flutter test` passes with **100% green test execution**.

---

## 📄 License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
