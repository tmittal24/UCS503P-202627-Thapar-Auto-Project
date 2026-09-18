# Trijal — Backend / Matching Engine / Booking Transaction

## Week 1 — Project Pitch Deck

Contributed to the initial Thapar Auto pitch, focused on defining the core problem the app solves.

Framed the problem as the everyday campus auto experience: students wait at stops with no idea when an auto is coming or whether it has room, autos leave half-empty on some routes and overflow on others, and fares are negotiated ad hoc with no fixed rate.
Argued that the real technical opportunity was pooling — letting a student join an auto that is already enroute in the same direction with spare seats, instead of always dispatching a fresh one. This became the central idea the rest of the deck was built around.
Pushed for keeping the first version scoped to a single fixed set of campus stops in a known order, rather than open-map routing, so that "same direction" and "still ahead of the auto" could be reasoned about cleanly.

## Week 2 — Project Proposal

Wrote the methodology and system-architecture sections of the proposal, owning the backend and matching side.

Specified the stack: Node/Express API with SQLite (better-sqlite3) for storage, chosen over a heavier DB because the prototype runs on a single instance and synchronous queries keep the booking transaction simple to reason about.
Laid out the data model up front — locations (with a stop_order), students, drivers, autos, and bookings — and made the case that stop_order is the backbone of the whole system, since direction and pooling eligibility are both derived from it.
Made an explicit scope decision: no live GPS tracking in this stage. Auto position is modeled as a current_stop_order that advances along the fixed stop list, not real coordinates. Documented this as an intentional, reversible cut — the matching logic doesn't change when real location data is added later.
Fixed the fare model as a flat per-seat rate rather than distance-based pricing, again to keep the first version's booking transaction deterministic and testable.

## Week 3 — Matching Engine and Booking Transaction

Split the week between the pooling algorithm and making the booking write safe under concurrent requests.

### Direction and pooling logic

Defined direction from the pickup and drop stop_order (FORWARD = increasing, BACKWARD = decreasing) and built the two predicates the whole matcher rests on: whether a stop is still ahead of an auto given its direction, and whether a stop falls within an auto's already-committed route span.
Wrote findPoolableAuto to pick, among enroute autos going the same direction with enough free seats, one where the student's pickup hasn't been passed yet and the drop is reachable on the route. When a poolable auto is found, the auto's end stop is extended (max for FORWARD, min for BACKWARD) so the route grows to cover the new drop.
Added a separate findAllPoolableAutos that returns every eligible auto rather than just the best one, so the availability screen can show the student all their join options with per-auto remaining seats, without booking anything.
Kept an idle auto queue ordered by queued_at, and made completed trips rejoin the back of it — a cyclic queue — so dispatch is fair across drivers instead of always hitting the same auto.

### Booking safety

Wrapped the whole requestBooking flow in a single database transaction: find-or-dispatch the auto, update its route span and seat count, and insert the booking as one atomic unit, so two students can't both claim the last seat.
Made requestBooking fall back cleanly — try to pool first, and only pull a fresh auto from the idle queue if nothing poolable fits, marking the result so the caller knows whether the trip was pooled or newly dispatched.
Cross-checked seat math against capacity in both the pool path and the fresh-dispatch path after catching a case where a request larger than the idle auto's capacity would otherwise have been accepted.

## Week 4 — DFD Level 2 and Use-Case Relations (Booking & Payment / Matching)

Owned the deepest layer of the system design diagrams — the decomposition of Booking & Payment — plus the include/extend relations on the use-case diagram that touch matching.

### Level 2 DFD (Booking & Payment)

Owned the Level 2 decomposition of Booking & Payment, breaking process 3.0 into four sub-processes: Find Poolable Auto (3.1), Dispatch from Idle Queue (3.2), Create Booking Record (3.3), and Confirm UPI Payment (3.4), drawn directly from the pool-first-then-fallback logic in requestBooking.
Modeled the branch explicitly as two outgoing flows from 3.1 — "No Match Found" into 3.2 and "Match Found" straight into 3.3 — so the diagram shows the fallback as a real decision point rather than two independent, unconnected paths.

### Use-case diagram relations

Owned the include relation on the use-case diagram from Request Booking to View Live Availability, to represent that a booking request always runs an availability check first. Deliberately did not add an include or extend anywhere else on the diagram unless it was semantically a mandatory sub-step, and caught one incorrectly drawn relation between two different actors' use cases during review, which got removed.

### Level 1 DFD

Defined the two internal flows for Availability & Matching (2.0): reading stops and order from the Locations store, and reading auto status and route from the Autos store, since both are needed before 3.1 can even run.
Cross-checked the Level 2 diagram against the use-case diagram afterward and found an inconsistency: the use-case diagram implied dispatch-from-queue was part of Request Booking, but the DFD didn't show it as a labeled sub-flow. Fixed by adding the explicit "No Match Found" flow into 3.2 so both diagrams agree on dispatch being a real fallback branch, not an implementation detail hidden inside 3.1.
