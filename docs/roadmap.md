| Week | Core Sprint Goal | Build Tasks (Mon → Fri) | Checkpoints / Review |

|------|------------------|-------------------------|----------------------|

| \*\*1\*\* | \*\*Wallet \& Auth Foundation\*\* | • Set up Firebase project.<br>• Phone-number + OTP login (Firebase Auth).<br>• Firestore `users/{uid}` doc with starting balance = 0.<br>• Basic Flutter screens: Sign-in, Home with balance. | \*\*Fri Demo:\*\* two test phones register, log out/in, see balance. |

| \*\*2\*\* | \*\*Task \& Reward Mini-CMS\*\* | • Flask micro-admin (or Firestore rules) to CRUD tasks, rewards.<br>• Add `owner:"GiveBackBB"` field.<br>• Pre-load 3 NTI courses (Digital Literacy, Intro Python, Excel Basics).<br>• App: task-list screen with org icon \& points. | \*\*Fri Demo:\*\* Admin creates a new task; it appears in app. |

| \*\*3\*\* | \*\*Verification SDK v0 \& File Upload\*\* | • Flutter: deep-link opens NTI course in WebView.<br>• Implement file picker (PDF / image).<br>• Cloud Storage + Cloud Function: on upload → create `taskLog` (`status=PENDING`).<br>• Show “Awaiting verification” toast. | \*\*Wed Check:\*\* upload works.<br>\*\*Fri Demo:\*\* `taskLog` appears in Firestore console. |

| \*\*4\*\* | \*\*Auto-Token Mint \& Redeem Stub\*\* | • Cloud Function verifies upload (size > 50 KB) → `status=VERIFIED`, increment balance.<br>• Redeem screen: pick mock “Flow 1 GB Data Voucher (50 Tokens)”, subtract balance, display dummy PIN.<br>• Store IMEI hash to limit multi-account farming. | \*\*Fri Demo:\*\* Upload certificate → +50 tokens → redeem voucher. |

| \*\*5\*\* | \*\*Trust-Score \& Analytics Dashboard\*\* | • Trust Score = Σ tokens + (7-day streak × 5).<br>• React/Firebase dashboard: total users, tokens, NTI completions.<br>• “GiveBackBB Admin” role shows only their data. | \*\*Thu:\*\* dashboard link shared.<br>\*\*Fri Retro:\*\* metrics live. |

| \*\*6\*\* | \*\*Pilot On-Board \& Feedback Loop\*\* | • Recruit 25 youth testers.<br>• Send onboarding PDF with QR link to app.<br>• 48-hour pilot: each completes 1 NTI course.<br>• Collect feedback (Google Form).<br>• Draft \*\*Good Bank Rules v0.1\*\* (roles, token math, privacy). | \*\*Wed:\*\* mid-pilot MAU \& error check.<br>\*\*Fri Final Demo:\*\* live stats, 3 real redemptions, pilot findings \& next-step backlog. |



