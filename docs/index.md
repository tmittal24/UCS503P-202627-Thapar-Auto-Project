![Tiet Logo](assets/tiet-logo.svg){ .tiet-logo }

**UCS503: Software Engineering (Project)**  
**Thapar Institute of Engineering & Technology, Patiala**

# **Thapar Auto: Shared Campus Auto-Rickshaw System**
### ***A Stop-Ordered Ride Pooling, Dispatch & UPI Settlement Platform***

<div class="badges" markdown>
[![Frontend](https://img.shields.io/badge/Frontend-Flutter%20%2F%20Dart-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2F%20Express-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://expressjs.com/)
[![Database](https://img.shields.io/badge/Database-SQLite%20%2F%20better--sqlite3-003B57?style=flat-square&logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Auth](https://img.shields.io/badge/Auth-Firebase%20%2F%20Google%20Sign--In-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Documentation](https://img.shields.io/badge/Docs-MkDocs%20%2F%20LaTeX-008080?style=flat-square)](https://www.mkdocs.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://github.com/tmittal24/UCS503P-202627-Thapar-Auto-Project)
</div>

---

## Academic & Team Profile

| Role | Team Member | Roll Number | Department |
| :--- | :--- | :--- | :--- |
| **Backend Architect & Matching Engine Lead** | **Trijal** | <span style="white-space: nowrap;">`1024030784`</span> | Computer Science & Engineering |
| **Frontend Architect & Student Flow Lead** | **Tushit** | <span style="white-space: nowrap;">`1024031079`</span> | Computer Science & Engineering |
| **Driver Systems & Trip Lifecycle Lead** | **Arpita** | <span style="white-space: nowrap;">`1024030778`</span> | Computer Science & Engineering |

* **Course Code:** UCS503P — Software Engineering Project (Academic Year 2026–27)

---

## Executive Overview

Students waiting at campus auto stops have no way of knowing when the next auto will arrive or whether it will have room. Autos leave half-empty on some routes while students overflow on others, and fares are negotiated ad hoc with no fixed rate.

**The Pooling Problem:**
The inefficiency is not a shortage of autos — it is that each auto is treated as a **single-booking unit**. An auto already travelling in a student's direction, with spare seats, is invisible to that student. Every request therefore dispatches a fresh vehicle, and capacity is wasted on both sides of the market.

**Thapar Auto** solves this by making an in-progress trip a joinable resource:

1. **Stop-Ordered Route Model:** The campus is modelled as a fixed, ordered list of stops. Direction and reachability are derived from `stop_order`, not open-map routing, so "same direction" and "still ahead of the auto" are exactly computable.
2. **Pool-First Matching:** Every booking request first searches enroute autos heading the same direction with free seats, extending the matched auto's route span to cover the new drop stop.
3. **Cyclic Idle-Queue Fallback:** If no auto is poolable, the next vehicle is pulled from a queue ordered by idle time, and completed trips rejoin the back — keeping dispatch fair across drivers.

---

## Key Platform Capabilities

<div class="grid cards" markdown>

-   :material-map-marker-path: **Stop-Ordered Route Modelling**

    ---

    The campus is represented as a fixed, ordered list of stops. Travel direction is derived as `FORWARD` (increasing `stop_order`) or `BACKWARD` (decreasing), making pooling eligibility a deterministic comparison rather than a geospatial estimate.

-   :material-account-multiple-plus: **Pool-First Matching Engine**

    ---

    Each request scans enroute autos for the same direction, sufficient free seats, an unpassed pickup stop, and a reachable drop stop. On a match, the auto's route span is extended to absorb the new drop.

-   :material-sync: **Cyclic Idle Dispatch Queue**

    ---

    When nothing is poolable, the longest-idle auto is dispatched. Completing a trip clears the auto's seats, direction, and route span atomically and returns it to the back of the queue with a fresh timestamp.

-   :material-database-lock: **Transactional Booking Safety**

    ---

    Finding-or-dispatching the auto, updating its route span and seat count, and inserting the booking execute as a single database transaction, so concurrent requests can never both claim the final seat.

-   :material-qrcode-scan: **Direct UPI Settlement**

    ---

    Each driver uploads their own UPI QR code at onboarding. The platform computes the flat per-seat fare and displays the driver's QR — it never custodies or processes funds itself.

-   :material-shield-account: **Domain-Restricted Authentication**

    ---

    Google Sign-In is restricted to `@thapar.edu` accounts on the client, with the backend independently re-validating the domain at student creation so the restriction is enforced rather than merely suggested.

</div>

---

## System Architecture & Layered Decomposition

The platform separates client interaction, matching logic, and persistence across 3 modular layers:

<div class="grid cards" markdown>

-   :material-cellphone-link: **Client Application (Flutter / Dart)**

    ---

    - Student booking flow with live availability preview
    - Driver dashboard: queue position, riders, trip completion
    - Centralised `api_service` network boundary
    - Provider state management, `shared_preferences` sessions

-   :material-server-network: **Backend API (Express / Node.js)**

    ---

    - REST endpoints for locations, availability, bookings, drivers
    - Pool-first matching engine with idle-queue fallback
    - Atomic booking transaction with capacity validation
    - `multer` multipart handling for UPI QR uploads

-   :material-database: **Data Layer (SQLite / better-sqlite3)**

    ---

    - Locations with `stop_order` as the routing backbone
    - Students, Drivers, and Autos as separate concerns
    - Bookings linking student, auto, pickup and drop stops
    - Synchronous queries for transactional simplicity

</div>

---

## Interactive Prototype Demonstration

To run the full stack locally, start the API server first, then launch the Flutter client against it.

**Terminal 1: Start Backend API**
```bash
cd code/backend
npm install
npm start
```

**Terminal 2: Start Flutter Application**
```bash
cd code/frontend
flutter pub get
flutter run
```

!!! note "Configuration prerequisites"
    The client reads its API host from `lib/config/`. Update the base URL there if the backend is not on the default host. Firebase credentials (`google-services.json`) must be supplied locally for Google Sign-In; they are deliberately excluded from version control.

---

## Formal Software Engineering & Architectural Deliverables

| Deliverable | Description | Format & Access Link |
| :--- | :--- | :--- |
| **Project Proposal Report** | Formal LaTeX proposal detailing problem formulation, scope, methodology, and system architecture | [View Proposal PDF](project-proposal/thapar_auto_proposal.pdf) |
| **Project Pitch Deck** | Initial pitch framing the pooling opportunity and four-part system story | [View Pitch Deck](Campus-Ride-Deck.pptx) |
| **Prototype Evaluation Report** | Evaluation of the working prototype, matching engine, and booking transaction | [View Prototype Report PDF](prototype_document.pdf) |
| **Prototype Presentation Deck** | Prototype-stage evaluation deck with architecture walkthrough | [View Slide Deck](Thapar_Auto_Prototype_Presentation.pptx) |
| **System Design Compendium** | Consolidated Mermaid source for use-case, DFD, ER, and activity diagrams | [View Design Document](Thapar_Auto_System_Design_Diagrams.md) |
| **UML Use Case Diagram** | Actor boundaries and include relations across Student and Driver | [View Use Case Diagram](usecase_diagram.png) |
| **Entity-Relationship Diagram** | Database schema across Student, Booking, Auto, Driver, and Location | [View ER Diagram](er_diagram.png) |
| **Data Flow Diagram — Level 0** | Context diagram of the system and its two external entities | [View Level 0 DFD](DFD_level_0.jpeg) |
| **Data Flow Diagram — Level 1** | Decomposition into Registration, Matching, Booking, and Trip Management | [View Level 1 DFD](DFD_level_01.jpeg) |
| **Data Flow Diagram — Level 2** | Decomposition of Booking & Payment into the pool-then-dispatch branch | [View Level 2 DFD](DFD_level_02.jpeg) |
| **UML Activity Diagram** | Swimlane workflow from stop selection through payment and trip completion | [View Activity Diagram](activity_diagram.jpg) |

---

<p align="center">
  <b>Thapar Auto</b> • Shared Campus Auto-Rickshaw Pooling & Dispatch • Academic Year 2026-27
</p>
