# Project Blueprint: CheckMate Sugar Tracker

## 1. Overview

This document outlines the development plan for **CheckMate**, a Flutter application designed to help users monitor their glucose levels. The initial phase focuses on building a secure, user-friendly, and visually appealing authentication system.

## 2. Core Features & Design

### Design System
- **Font:** **Raleway**. This will be the primary font for the application, sourced from `google_fonts`.
- **Colors:**
  - **Primary:** A dark grey (`#424242`) for text, icons, and key elements.
  - **Accent/Error:** A strong red (`#D32F2F`) for errors and highlights.
  - **Background:** A light, wave-like gradient as seen in the login screen design (shades of blue and green).
- **Radius:** A default corner radius of **10.0** (`0.625rem`) will be used for cards, buttons, and input fields to ensure a consistent, modern look.

### Authentication Flow
1.  **Login Screen (`/`):**
    *   Email and Password fields.
    *   "Remember me" checkbox.
    *   **"Forgot password?"** link navigating to a password reset screen.
    *   A primary "Sign In" button.
    *   A "Sign up" link for new users.
    *   A "Continue with Google" button.
2.  **Sign-Up Screen (`/signup`):**
    *   Fields for Email and Password.
    *   A "Sign Up" button.
    *   A link to navigate back to the Login screen.
3.  **Password Reset Screen (`/forgot-password`):**
    *   An email field for the user.
    *   A button to send a password reset link.
4.  **Dashboard Screen (`/dashboard`):**
    *   A protected screen for authenticated users.

## 3. Technical Implementation Plan

1.  **Re-scaffold the Project:**
    *   Create a new, correct `lib/auth_service.dart` for Firebase Authentication logic.
    *   Verify `pubspec.yaml` has `firebase_core`, `firebase_auth`, `google_sign_in`, `provider`, `go_router`, and `google_fonts`.
2.  **Set Up App Entry & Theming:**
    *   Rewrite `lib/main.dart` to initialize Firebase, set up providers, configure `go_router`, and define the application's `ThemeData` based on the specified **Design System**.
3.  **Build UI Screens:**
    *   Develop `lib/login_screen.dart` to match the UI, incorporating the design system.
    *   Develop `lib/signup_screen.dart`.
    *   Create `lib/forgot_password_screen.dart`.
4.  **Manage Authentication State:**
    *   Implement `lib/auth_wrapper.dart` for automatic redirection.
5.  **Iterative Verification:**
    *   Run `flutter pub get` and `flutter analyze` after each major step.
