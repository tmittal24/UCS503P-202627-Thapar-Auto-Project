# Arpita — Driver / Onboarding / Trip Lifecycle

## Week 1 — Project Pitch Deck

Contributed the supply side of the pitch — the drivers, without whom there is nothing to book.

Argued that the app has to give drivers a reason to join, not just students, and framed pooling as that reason: fuller autos per trip and a steady dispatch queue instead of idle waiting and haggling.
Raised early that payments should route directly to the driver rather than through the app holding money, which set the direction toward each driver bringing their own UPI QR code.
Helped shape the deck's four-part story so the driver dashboard and the trip lifecycle (idle, enroute, complete) were shown as first-class parts of the system, not an afterthought bolted onto the student flow.

## Week 2 — Project Proposal

Owned the data-model and driver-onboarding parts of the proposal.

Defined the drivers and autos tables and the deliberate split between them: a driver is a person (name, phone, vehicle number, QR image), while an auto is the bookable unit with capacity, status, seat count, and route span. Kept them separate so a driver's identity never mixes with the fast-changing trip state written on every booking.
Restricted capacity to 4, 5, or 7 to match real auto sizes on campus, and documented it as a validated constraint rather than a free integer, so a bad onboarding value fails at creation instead of corrupting seat math later.
Specified QR-image upload at driver onboarding (multipart, size-capped, stored on disk and served back as a URL) as the payment mechanism, and documented that the app never processes the payment itself — it only shows the driver's QR.
Wrote the resources section around this being a single-instance prototype: local SQLite file, local file storage for uploads, manual run, with cloud deployment listed as out of scope for this stage.

## Week 3 — Driver Dashboard, Onboarding, and Trip Lifecycle

Built the driver-facing half of the app and closed the loop on the trip lifecycle.

### Onboarding and dashboard

Built the driver onboarding path against the /drivers endpoint, including the QR-image pick and upload via image_picker, and validated capacity on the client to one of the allowed sizes before sending, mirroring the backend check.
Built the driver dashboard to show the auto's current status, the seats booked against capacity, and — while idle — its position in the dispatch queue via the queue-position endpoint, so a waiting driver can see they are, for example, third in line rather than staring at an empty screen.
Listed the current trip's riders on the dashboard by joining bookings to students on the backend, so the driver can see who is aboard, their pickup and drop, and each fare.

### Trip lifecycle and integration

Wired the complete-trip action so that when a driver ends a trip the auto resets — seats cleared, route span cleared, status back to idle — and rejoins the back of the cyclic queue with a fresh queued_at timestamp, keeping dispatch fair.
Traced one integration bug end to end: after a trip completed, a stale route span was briefly still visible to the matcher, letting a new request pool onto an auto that had just gone idle. Fixed by clearing direction and the start/current/end stop orders in the same update that flips status to idle, so the reset is atomic.
Sat with the frontend and backend owners to confirm the pooled-vs-fresh flag, the fare, and the QR URL all lined up across the booking response, the student payment screen, and the driver dashboard, since all three read the same booking record.

## Week 4 — Use-Case Diagram and DFDs (Driver Side)

Modeled the driver half of the use-case diagram and the driver-facing flows across the DFDs, working from the same notation used for the rest of the system design.

### Use-case diagram

Modeled the driver half of the diagram: five use cases (Register Vehicle & Upload QR Code, Join Idle Queue, View Current Trip's Bookings, View Queue Position, Mark Trip Complete) connected to the Driver actor, plus the shared Login/Register use case connected to both actors since auth isn't role-specific.
Added the include relation from Register Vehicle & Upload QR Code to Login/Register, mirroring the same include already drawn for the student's booking use case, since a driver can't register a vehicle without first being authenticated.

### DFDs

On the Level 0 context diagram, defined the driver-facing flows: Registration & QR Code and Trip Completion going in, Assigned Bookings, Queue Position, and Trip Alerts coming out, matching exactly what the dashboard and onboarding screens send and receive.
On the Level 1 DFD, mapped driver interactions to two processes: Registration (1.0), where driver details create both a Users record and an Autos record in the same step, and Trip & Queue Management (4.0), where completing a trip updates the auto's status and queue position and reads back bookings for the driver's dashboard.
Caught one inconsistency while cross-checking against Trijal's Level 2 decomposition: the driver-side Level 1 flow showed Trip & Queue Management only updating status and queue position, but didn't show it clearing route span, even though that's the actual reset from Week 3. Fixed by widening the P4-to-DB_Autos flow label to "Update Status, Route Span, Queue Position" so the diagram matches the atomic reset rather than implying two separate writes.
