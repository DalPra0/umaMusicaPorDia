# Bentô

[![App Store](https://img.shields.io/badge/App%20Store-Bent%C3%B4-0D96F6?style=for-the-badge&logo=appstore&logoColor=white)](https://apps.apple.com/br/app/bent%C3%B4/id6760786880) [![Website](https://img.shields.io/badge/site-bentô-111111?style=for-the-badge)](https://dalpra0.github.io/BentoWebsite/)

A daily nostalgia collage app. Every day a notification brings a new nostalgic theme; you build the most creative collage inside your "box", compare it with friends and keep it in a visual diary. Published on the App Store. (The repository is named `umaMusicaPorDia` for historical reasons.)

<p>
  <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/d2/8b/b1/d28bb11a-7358-6e11-a0a3-4f38a1964cff/Frame1.png/300x650bb.jpg" width="200" alt="Bentô home"/>
  <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/77/30/94/77309419-e155-cb9e-9308-4009d22535a6/Frame2.png/300x650bb.jpg" width="200" alt="Collage editor"/>
  <img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/ee/b1/83/eeb183a9-d68b-dc72-f76a-d63f9ab861ff/Frame3.png/300x650bb.jpg" width="200" alt="Daily collection"/>
</p>

## What it does
- A new word/theme every day, delivered by local notification.
- Collage canvas with layers, strokes, colors, basket variants and image import.
- Home screen widget and a Share extension to send images to Bentô.
- Account and sync, plus a Pro tier.

## How it is built
- **Swift and SwiftUI**, MVVM (`ViewModels/`, `Services/`).
- **Supabase** for auth and data (`SupabaseService`, `AuthService`, `CollageService`); the daily word comes from a TypeScript generator (`generate-daily-word.ts`).
- **RevenueCat** for the Pro tier (`SubscriptionManager`), through Swift Package Manager.
- **WidgetKit** widget and a **Share extension**; image compression and rendering helpers; haptics.
- Requires iOS 18.6 or later.
- The landing page lives in `umaMusicaPorDiaProject/BentoWebsite`.

## Author
Lucas Dal Pra Brascher · [dalpra0.dev](https://dalpra0.dev) · [LinkedIn](https://www.linkedin.com/in/lucas-dal-pra-2115692b6/)
