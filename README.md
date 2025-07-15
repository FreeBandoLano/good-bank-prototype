\# Good Bank – 6-Week MVP 📲💙



Digital-public-infrastructure prototype rewarding Barbadian youth for \*\*verified learning\*\*  

(NTI courses) and \*\*community deeds\*\* (Give Back Barbados). Built with Firebase, Flutter, and

Cloud Functions.



---



\## Sprint Road-map (42 days)



| Sprint | Focus                                   | Status |

| :----: | --------------------------------------- | :----: |

| \*\*1\*\*  | Smart Id verification w/ APDU cmds      | ⏳ |

| \*\*2\*\*  | Task / Reward Mini-CMS                  | ⏳ |

| \*\*3\*\*  | Certificate Upload + Verification SDK   | ⏳ |

| \*\*4\*\*  | Token Mint + Voucher Redeem Stub        | ⏳ |

| \*\*5\*\*  | Trust Score \& Analytics Dashboard      | ⏳ |

| \*\*6\*\*  | 25-user Pilot \& Feedback Loop          | ⏳ |



Progress tracked in the \*\*Project Board\*\* → Kanban columns `Week 1 … Week 6`.



---



\## Quick Start (Dev)



\### Mobile App 📱

```bash

cd mobile\_app

flutter pub get

flutter run  # connect Android device or emulator

--

DOC LINK >>> https://docs.google.com/document/d/1eVzHYiMukwKWi42NQZyJIFFrX0YPqRIbhRNE9AUroYU/edit?usp=sharing

## Human-Centered Design Considerations

### User Onboarding
- Youth participants sign up using their national ID.
- This triggers the creation of a Self-Sovereign Identity (SSI) via OpenID Connect.

### Credential Creation and Storage
- Data from the national ID (e.g., name, ID number, address) is saved as **verifiable credentials** in the youth's SSI wallet.
- **No personal data is stored in a centralized database.**

### Partner-Issued Credentials
- Partners issue additional credentials based on:
  - Online learning (e.g., COURSERA courses)
  - Community service and impact
  - Barbados Give-back or volunteering
- Each credential type is structured as a **unique schema** to capture key data (e.g., hours of learning completed).

### Criteria-Based Verification for Benefits
- Verifiers offer benefits based on youth meeting **specific criteria**:
  - Example: 10 hours internship, 3 hours learning, 1 community task
- The system checks if criteria are met and returns a **binary result** (Met / Not Met).
- **No personal data** is shared with verifiers.
- Youth select what data to share via a dropdown-style interface (e.g., no phone number or address).

---

### Assumptions on User Behavior

**Youth Motivation**  
- Youth are incentivized to use the platform (to earn credentials and authorize data sharing) in exchange for a reward or opportunity.

**Issuer Participation**  
- Issuers (e.g., NGOs or course providers) understand:
  - The implications of issuing a credential
  - The importance of accuracy
  - Risks of issuing false or unverified credentials

**Verifier Trust**  
- Verifiers trust the returned credential status without needing raw data or future evidence.
- They are willing to issue rewards **based solely on system verification.**

---

### Pilot Goals
- Test usability and motivation for all user groups.
- Evaluate trust in the system without revealing sensitive personal information.
- Assess feasibility of decentralized verification for real-world benefit delivery.

