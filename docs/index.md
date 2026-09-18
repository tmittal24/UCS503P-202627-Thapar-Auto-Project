![Tiet Logo](assets/tiet-logo.svg){ .tiet-logo }

**UCS503P — Software Engineering Project**
**Thapar Institute of Engineering & Technology, Patiala**

# Thapar Auto

*Because the auto three stops ahead already has room for you.*

Built with Flutter · Node.js/Express · SQLite · Firebase Auth — licensed MIT.

---

## Who built this

Three people, three lanes of the same system:

- **Trijal** (`1024030784`) — owns the backend: the matching engine and the booking
  transaction that has to stay correct under concurrent requests.
- **Tushit** (`1024031079`) — owns the frontend: the student's path from picking a
  stop to paying for the ride.
- **Arpita** (`1024030778`) — owns the driver side: onboarding, the dispatch queue,
  and closing out a trip cleanly.

Supervising course: UCS503P, Academic Year 2026–27.

---

## Why this exists

Anyone who's waited at a campus auto stop knows the drill: no idea when the next one
shows up, no idea if it has room, and the fare gets negotiated on the spot every time.
Meanwhile autos leave half-full on quiet routes and overflow on busy ones — the supply
is fine, it's just not being used well.

The fix isn't more autos. It's treating a trip that's *already happening* as something
a new rider can join, instead of always sending out a fresh vehicle.

## The matching logic, in short

1. **Stops have a fixed order.** No live GPS in this version — every stop on campus
   has a `stop_order`, and an auto's position is just how far along that list it's
   gotten. That's enough to know direction and whether a stop is still ahead of it.
2. **Try to pool first.** A new request checks every enroute auto going the same way
   with a free seat. If one's route already reaches (or can be stretched to reach)
   the drop stop, the rider joins it and the route extends.
3. **Otherwise, dispatch.** Nothing poolable? Pull the auto that's been idle longest
   from a queue. When a trip ends, that auto goes back to the end of the same queue —
   so no driver gets skipped over.
4. **One transaction, no double-booking.** Finding the auto, updating its seats and
   route, and writing the booking all happen inside a single database transaction.
5. **Settlement is peer-to-peer.** Fare is seats × a flat per-seat rate. Payment goes
   straight to the driver's own UPI QR code — the app never holds anyone's money.

The full reasoning behind each of these — including where the team second-guessed
itself — is in the journals linked in the sidebar. The formal diagrams are on the
[System Design Diagrams](Thapar_Auto_System_Design_Diagrams.md) page.

## What each side of the app does

| | Student | Driver |
|---|---|---|
| **Getting in** | Signs in with a `@thapar.edu` Google account | Registers vehicle details, seat capacity, and a UPI QR image once |
| **Main screen** | Picks pickup/drop stops and seat count; sees live availability before booking | Sees seats booked vs. capacity, and queue position while idle |
| **Mid-trip** | Sees whether they were pooled onto an existing auto or freshly dispatched | Sees the list of current riders — pickup, drop, fare — for the active trip |
| **Wrapping up** | Pays via the driver's UPI QR, fare shown as seats × flat rate | Taps "complete trip"; auto resets and rejoins the back of the queue |

## How it's put together

**Client — Flutter (Android + Web)**
Provider for state, a single `api_service` module so every network call and error
path lives in one place, `shared_preferences` so a returning user skips the role
picker.

**API — Node.js + Express**
Owns the pooling/dispatch decision and the booking transaction; `multer` handles
the QR image uploads at driver onboarding.

**Storage — SQLite via `better-sqlite3`**
Synchronous queries, single instance — a deliberate choice for a prototype where the
booking transaction needs to be easy to reason about, not distributed.

## Run it locally

```bash
# Terminal 1 — API
cd code/backend
npm install
npm start
```

```bash
# Terminal 2 — client
cd code/frontend
flutter pub get
flutter run
```

You'll need your own `google-services.json` for Google Sign-In — it's kept out of
version control on purpose.

## Reports, diagrams, and decks

| What it is | Where |
|---|---|
| Project proposal (LaTeX + PDF) — problem framing, methodology, architecture | [Proposal PDF](project-proposal/thapar_auto_proposal.pdf) |
| Week 1 pitch deck | [Campus-Ride-Deck.pptx](Campus-Ride-Deck.pptx) |
| Prototype-stage evaluation report | [prototype_document.pdf](prototype_document.pdf) |
| Prototype-stage presentation | [Thapar_Auto_Prototype_Presentation.pptx](Thapar_Auto_Prototype_Presentation.pptx) |
| Use-case diagram, DFDs (L0–L2), ER diagram, activity diagram | [System Design Diagrams](Thapar_Auto_System_Design_Diagrams.md) |

---

<p align="center"><sub>Thapar Auto — UCS503P Software Engineering Project, 2026–27</sub></p>
