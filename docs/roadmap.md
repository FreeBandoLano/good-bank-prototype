| Week | Core Sprint Goal | Build Tasks (Mon → Fri) | Checkpoints / Review |

|------|------------------|-------------------------|----------------------|

| \*\*1\*\* | \*\*Wallet \& Auth Foundation\*\* | • Set up Firebase project.<br>• MRZ & NFC smart card reader (ReadId API).<br>• Firestore `users/{uid}` doc with starting balance = 0.<br>• Basic Flutter screens: Sign-in, Home with balance. | \*\*Fri Demo:\*\* two test phones register, log out/in, see balance. |

| \*\*2\*\* | \*\*Task \& Reward Mini-CMS\*\* | • Flask micro-admin (or Firestore rules) to CRUD tasks, rewards.<br>• Add `owner:"GiveBackBB"` field.<br>• Pre-load 3 NTI courses (Digital Literacy, Intro Python, Excel Basics).<br>• App: task-list screen with org icon \& points. | \*\*Fri Demo:\*\* Admin creates a new task; it appears in app. |

| \*\*3\*\* | \*\*Verification SDK v0 \& File Upload\*\* | • Flutter: deep-link opens NTI course in WebView.<br>• Implement file picker (PDF / image).<br>• Cloud Storage + Cloud Function: on upload → create `taskLog` (`status=PENDING`).<br>• Show “Awaiting verification” toast. | \*\*Wed Check:\*\* upload works.<br>\*\*Fri Demo:\*\* `taskLog` appears in Firestore console. |

| \*\*4\*\* | \*\*Auto-Token Mint \& Redeem Stub\*\* | • Cloud Function verifies upload (size > 50 KB) → `status=VERIFIED`, increment balance.<br>• Redeem screen: pick mock “Flow 1 GB Data Voucher (50 Tokens)”, subtract balance, display dummy PIN.<br>• Store IMEI hash to limit multi-account farming. | \*\*Fri Demo:\*\* Upload certificate → +50 tokens → redeem voucher. |

| \*\*5\*\* | \*\*Trust-Score \& Analytics Dashboard\*\* | • Trust Score = Σ tokens + (7-day streak × 5).<br>• React/Firebase dashboard: total users, tokens, NTI completions.<br>• “GiveBackBB Admin” role shows only their data. | \*\*Thu:\*\* dashboard link shared.<br>\*\*Fri Retro:\*\* metrics live. |

| \*\*6\*\* | \*\*Pilot On-Board \& Feedback Loop\*\* | • Recruit 25 youth testers.<br>• Send onboarding PDF with QR link to app.<br>• 48-hour pilot: each completes 1 NTI course.<br>• Collect feedback (Google Form).<br>• Draft \*\*Good Bank Rules v0.1\*\* (roles, token math, privacy). | \*\*Wed:\*\* mid-pilot MAU \& error check.<br>\*\*Fri Final Demo:\*\* live stats, 3 real redemptions, pilot findings \& next-step backlog. |

---

## Architecture Rationale — “Why these tools?”

| Layer / Tool | Why we chose it | Constraints it solves |
|--------------|-----------------|-----------------------|
| **Flutter 3** | One code-base → Android & iOS; hot-reload for demo speed. | We don’t have bandwidth to maintain separate native apps. |
| **Firebase** (Auth, Firestore, Storage, Functions, Hosting) | Turn-key backend, serverless, generous free tier; local emulators for offline dev. | No DevOps team; we need push-button infra that scales for a 25-user pilot. |
| **Phone-Number OTP (Flow/Digicel)** | Universally available ID vector; telcos already do basic KYC; integrates with Firebase Auth in minutes. | National Digital ID APIs aren’t public yet; we still need a trustable identity today. |
| **IMEI Hash** (stored with UID) | Soft device binding to discourage multi-account farming. | Prevents abuse until we can issue stronger verifiable credentials. |
| **Cloud Functions (Node 18)** | Write tiny serverless functions in JS; automatic Firebase security context. | No separate backend server; reduces attack surface. |
| **Flask Mini-Admin (Python)** | Quick CRUD panel for tasks & rewards; runs anywhere. | Waiting for a full CMS would delay content updates; Flask is 20 LOC to MVP. |
| **React + Firebase SDK Dashboard** | Real-time charts with minimal boilerplate; deployable to Firebase Hosting. | Gives sponsors live KPIs without extra BI tooling. |
| **GitHub Actions CI** | Lint, test, and build on every PR; free minutes. | No dedicated CI server; keeps code health visible to volunteers. |
| **QR + GPS proof** | Low-code verification method, works offline; same pattern Yoma used. | Biometric / NFC readers out-of-scope for 6-week timeline. |
| **Mock Airtime Vouchers** | Reward token → telco PIN in seconds; no fintech integration yet. | Cash-out requires central-bank clearance; airtime is instant & trusted. |
| **Good Bank Rules v0.1** (open governance doc) | Fork of UN/UNICEF Yoma Rules; lightweight policy while waiting for legal review. | Formal legislation may take months; interim rules provide transparency now. |

> **Principle:** choose the smallest, most battle-tested component that lets us demonstrate value **within 42 days**, while leaving a clean migration path to national e-ID, production cloud, and more advanced payout rails.

---




