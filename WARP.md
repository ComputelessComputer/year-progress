# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

Year Progress is a multi-platform app that displays time progress (year/month/day/custom) in various formats. The core concept: "A week is 2% of the year."

## Project Structure

```
apps/
├── macos/     # Native macOS menu bar app (Swift)
├── ios/       # iOS app (Swift)
├── web/       # Astro landing page
└── bots/      # Social media bots (Python)
```

## Build & Run Commands

### Web (`apps/web/`)
```bash
bun install              # Install dependencies
bun dev                  # Start dev server (http://localhost:4321)
bun run build            # Production build (outputs to dist/)
bun run preview          # Preview production build
```

### Bots (`apps/bots/`)
```bash
pip install -r requirements.txt    # Install dependencies
python x-bot.py                    # Run X/Twitter bot
python threads-bot.py              # Run Threads bot
```

Bots require environment variables: `API_KEY`, `API_SECRET`, `ACCESS_TOKEN`, `ACCESS_TOKEN_SECRET` (X) and `THREADS_USER_ID`, `THREADS_ACCESS_TOKEN` (Threads).

### macOS/iOS Apps
Open `apps/macos/YearProgressApp.xcodeproj` or `apps/ios/YearProgressApp.xcodeproj` in Xcode. Build with ⌘B, run with ⌘R.

## Architecture Notes

### macOS App (`apps/macos/YearProgressApp/AppDelegate.swift`)
- Single-file app using `NSStatusBar` for menu bar integration
- `ProgressMode` enum: `.year`, `.month`, `.day`, `.custom`
- Gauge icons at 5% increments (`gauge00.png` through `gauge100.png`) in Assets.xcassets
- Uses `SMAppService` for Launch at Login functionality
- Timer updates progress every 60 seconds

### Web App
- **Stack**: Astro 5, TypeScript, Tailwind CSS
- **Structure**: `src/pages/` for routes, `src/layouts/` for base layout, `src/components/` for reusable components
- **Pages**: Landing page (`/`), Privacy Policy (`/privacy`), Terms of Service (`/terms`)

### Bots
- GitHub Actions run daily at 9:00 AM UTC (X) and 9:15 AM UTC (Threads)
- Workflows in `.github/workflows/`
- Posts ASCII progress bars to social media

## Secrets Management

Bot credentials are stored as GitHub repository secrets in the `Production` environment. Never commit `.env` files.
