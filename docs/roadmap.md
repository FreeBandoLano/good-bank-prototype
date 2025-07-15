| Week | Core Sprint Goal | Build Tasks&nbsp;(Mon → Fri) | Checkpoints / Review |
|------|------------------|------------------------------|----------------------|
| **1** | **Identity + Hub Foundation** | • Create Firebase project.<br>• Integrate **ReadID SDK** (MRZ + QR) in Flutter.<br>• Cloud Fn **`issueToken()`** → returns Firebase **Custom Token**.<br>• Firestore `users/{uid}` doc with balance = 0.<br>• Basic Flutter screens: Scan ID → Home. | **Fri Demo:** scan card → instant login → user doc appears. |
| **2** | **Task + Reward Mini-CMS** | • Flask admin CRUD (`tasks`, `storeItems`).<br>• Field `owner:"GiveBackBB"`.<br>• Pre-load 3 NTI courses (Digital Literacy, Intro Python, Excel Basics).<br>• App: task-list with org icon & points. | **Fri Demo:** admin creates task; shows in app. |
| **3** | **Certificate Upload & Verify** | • Flutter file picker (PDF/image).<br>• Upload → Storage → CF **`verifyCert()`** (`status=PENDING`).<br>• Toast “Awaiting verification…”. | **Wed Check:** upload works.<br>**Fri Demo:** `taskLog` visible in Firestore. |
| **4** | **Token Mint & Voucher Redeem** | • `verifyCert()` size/checksum → `status=VERIFIED`.<br>• CF **`awardTokens()`** adds Sand-Dollar balance.<br>• Redeem screen: mock **Flow 1 GB voucher** (50 tokens) → display PIN.<br>• Store IMEI hash for fallback users. | **Fri Demo:** upload cert → +50 tokens → redeem PIN. |
| **5** | **Trust-Score & Dashboard** | • Trust Score = Σ tokens + (7-day streak × 5).<br>• React/Firebase dashboard: users, tokens, NTI completions.<br>• “GiveBackBB Admin” filter. | **Thu:** dashboard link shared.<br>**Fri Retro:** metrics live. |
| **6** | **Pilot On-Board & Feedback** | • Recruit 25 youth testers.<br>• Onboarding PDF w/ app QR.<br>• 48-h pilot: each completes 1 NTI course.<br>• Collect feedback (Google Form).<br>• Draft **Good Bank Rules v0.1**. | **Wed:** mid-pilot MAU & errors.<br>**Fri Final Demo:** live stats, ≥ 3 redemptions, pilot findings & next backlog. |

---

## Architecture Rationale — “Why these tools?”

| Layer / Tool | Why we chose it | Constraint solved |
|--------------|-----------------|-------------------|
| **ReadID SDK** | Card MRZ + QR scan; zero passwords; 30-day demo licence. | National e-ID chip inactive; need strong auth fast. |
| **Firebase Custom Token** | Converts ReadID payload into Firebase login in one HTTPS call. | Avoids own password/KYC store. |
| **SIM-OTP (Flow/Digicel) – fallback** | Inclusive path for damaged cards / no-camera phones. | Ensures no one blocked at pilot. |
| **Flutter 3** | Single code-base, hot-reload, low device RAM. | No bandwidth for separate native apps. |
| **Firebase** (Auth, Firestore, Storage, Functions, Hosting) | Turn-key serverless; local emulators. | No DevOps team; scales for 25-user pilot. |
| **Cloud Functions (Node 18)** | Tiny serverless functions (`issueToken`, `verifyCert`, `awardTokens`). | No backend server, low attack surface. |
| **Flask Mini-Admin** | 20-line CRUD for tasks & store items. | Full CMS would delay content; Flask is fast. |
| **React + Firebase SDK Dashboard** | Real-time charts, deploy via Firebase Hosting. | Live KPIs without extra BI tooling. |
| **GitHub Actions CI** | Lint, test, build on every PR (free minutes). | Keeps code health visible to volunteers. |
| **Mock Airtime Voucher API** | Reward tokens → telco PIN instantly. | Cash-out rails need central-bank clearance; airtime is immediate. |
| **Good Bank Rules v0.1** | Fork of UNICEF Yoma Rules; interim governance doc. | Formal legislation months away—need transparency now. |

> **Principle:** ship value in **≤ 14 days** with the smallest, battle-tested components, while leaving a clean migration path to SSI (Keycloak, Veramo, ACA-Py) for Phase 2.

---
