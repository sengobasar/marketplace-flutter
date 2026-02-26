# MarketPlace App

A mobile marketplace app built with Flutter where users can buy, sell, and exchange items — similar to OLX or Facebook Marketplace.

## Features

- Browse products in a grid layout with search and category filters
- View product details with seller info
- Post listings for sale or exchange
- Simulate secure payment with card details
- Make offers on listings
- In-app notifications with unread badge
- User login and registration
- Data stored in MongoDB

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter (Dart) |
| Backend API | Node.js + Express |
| Database | MongoDB |
| Auth | JWT + bcrypt |

## Prerequisites

Make sure you have these installed before running the app:

- [Flutter SDK 3.22+](https://flutter.dev/docs/get-started/install)
- [Dart 3.4+](https://dart.dev/get-dart)
- [Node.js 18+](https://nodejs.org)
- [MongoDB](https://www.mongodb.com/try/download/community) (local) or MongoDB Atlas
- [Android Studio](https://developer.android.com/studio) (for Android emulator)
- [VS Code](https://code.visualstudio.com) with Flutter & Dart extensions

## Project Structure

```
marketplace_app/
├── lib/
│   ├── models/         # Product, NotificationItem
│   ├── data/           # Mock data
│   ├── screens/        # All app screens
│   ├── widgets/        # Reusable widgets
│   └── services/       # API and Auth services
└── backend/
    ├── models/         # Mongoose schemas
    ├── routes/         # API endpoints
    ├── server.js
    └── .env
```

## Flutter Packages Used

| Package | Purpose |
|---------|---------|
| `http` | API calls to backend |
| `shared_preferences` | Save login token locally |
| `image_picker` | Pick images from gallery |
| `cupertino_icons` | iOS style icons |

## Backend Packages Used

| Package | Purpose |
|---------|---------|
| `express` | Web server framework |
| `mongoose` | MongoDB connection |
| `bcryptjs` | Password hashing |
| `jsonwebtoken` | User authentication |
| `dotenv` | Environment variables |
| `cors` | Allow Flutter to connect |

## Setup & Run

### 1. Backend
```bash
cd backend
npm install
node server.js
```

Make sure your `.env` file has:
```
PORT=5000
MONGODB_URI=mongodb://localhost:27017/marketplace
JWT_SECRET=your_secret_key
```

### 2. Flutter App
```bash
flutter pub get
flutter run
```

> For Android emulator, change `localhost` to `10.0.2.2` in `lib/services/api_service.dart`

## Screens

- **HomeScreen** — product grid with search and filters
- **ProductDetailScreen** — full product info with buy/offer buttons
- **AddProductScreen** — form to post a new listing
- **PaymentScreen** — simulated secure checkout
- **NotificationScreen** — list of alerts and offers
- **LoginScreen** — login and registration

## Notes

- Payment is simulated (no real transactions)
- Notifications are mock/in-app only
- Images are loaded from [picsum.photos](https://picsum.photos)
