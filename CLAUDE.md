# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

MSU Performance Appraisal system (ระบบประเมินผลการปฏิบัติราชการ) — a personnel-evaluation web app for Mahasarakham University, built on the Sakai Nuxt admin template. The UI is almost entirely in Thai. Despite the `sakai-nuxt` package name and the generic Nuxt starter README, this is a production internal application, not a template.

## Commands

```bash
yarn install          # install deps (yarn is the package manager; yarn.lock is committed)
npm run dev           # dev server on http://localhost:3000 (base path /evaluate/)
npm run build         # production build
npm run preview       # preview production build
npm run lint          # eslint over .js/.vue
npm run lint:fix      # eslint autofix
npm run format        # prettier --write **/*.{js,vue,d.ts}
npm run format:check  # prettier check only
```

There is no test suite.

## Architecture

**Nuxt 3 + PrimeVue front-end, external Laravel back-end.** This is the single most important thing to understand:

- The Nuxt app is essentially a **front-end only**. Almost all data operations (~580 call sites) are `axios` requests to a **separate Laravel API at `http://127.0.0.1:8000`** (`/api/...`, `/storage/...`). That Laravel backend is **not in this repo**.
- The Nuxt `server/` directory does almost nothing except host the auth handler. Do not expect business logic or a database layer here.
- `prisma/` (MySQL `train` DB) exists but is vestigial — two trivial models, not wired into the app flow. Ignore it unless explicitly working on it.

**Auth** — `@sidebase/nuxt-auth` (authjs strategy, JWT sessions) with a custom OAuth 2.0 provider `erpauth` pointing at MSU's ERP (`erp.msu.ac.th/authen/...`). Config lives in `server/api/auth/[...].js` and the `auth:` block of `nuxt.config.js`. The signed-in user's ERP profile is stored on `session.user.name` (note: `name` holds the whole profile object, e.g. `sessionData.user.name.STAFFID`, `.SCOPES.groupid`, `.SCOPES.staffdepartment`). Read it via `useAuthState()` / `useAuth()`. Pages default to requiring auth; use `definePageMeta({ auth: false })` to opt out (see `pages/index.vue`).

**Role-based menu** — `layouts/AppMenu.vue` calls the Laravel `POST /api/testUser` with the current `STAFFID` + department, gets back a `status_user` code, and filters which menu groups render. Roles: `99` general user, `2` HR, `3` department head, `4` executive, `5` admin. This is UI gating only; real authorization must be enforced by the Laravel backend.

**Layout** — Sakai template structure. `layouts/default.vue` → `layouts/AppLayout.vue` composes `AppTopbar`, `AppSidebar`/`AppMenu`, `AppFooter`, `AppConfig`. Shared layout/theme state (menu mode, scale, theme, dark mode) is a module-level reactive singleton in `layouts/composables/layout.js`, consumed via `useLayout()`.

**Pages** — Feature pages live in `pages/setting/` (the TOR/ป.01–ป.04 evaluation forms, dashboards, tracking, HR admin, digital signature, etc.). Routing is Nuxt file-based; the app runs under base path `/evaluate/`.

## Conventions & gotchas

- **`nuxt.config.js` is the live config** (`typescript: false`). Ignore `nuxt.config copy.js` and `nuxt.config.ts` references — the `.js` file is authoritative.
- **Environment switching is manual and comment-driven.** Swapping between `localhost`, `pa.msu.ac.th`, and `survey.msu.ac.th` is done by commenting/uncommenting blocks (baseURL, redirect_uri, clientId/clientSecret) in `nuxt.config.js`, `server/api/auth/[...].js`, and `.env`. When changing environments, update all three together. Note the OAuth client secrets and `AUTH_SECRET` are currently hardcoded/committed.
- **Backup files litter `pages/setting/`.** Many files are dated/`copy` snapshots (e.g. `por04 030769.vue`, `checkedialy copy 2.vue`, `tracking-260669.vue` — dates are Thai Buddhist-calendar `DDMMYY`). The *unsuffixed* filename is the active one (`por04.vue`, `tracking.vue`). Do not edit a backup thinking it's live, and be aware filenames with spaces become odd routes.
- **PrimeVue is globally auto-registered** via `nuxt-primevue`; the `Editor` component is excluded. `plugins/primevue.js` additionally registers `Button`. PrimeVue 3 + PrimeFlex 3, Aura Light Green theme (served from `/evaluate/themes/...`).
- Data fetching is done with `axios` directly (imported per-file), not `$fetch`/`useFetch`. Follow the existing pattern when adding calls to the Laravel API.
- User feedback uses `sweetalert2`; Thai UI strings are inline in templates.
