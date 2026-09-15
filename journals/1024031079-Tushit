# Tushit — Frontend / Student Booking Flow

## Week 1 — Project Pitch Deck

Owned the user-experience framing in the pitch, arguing the app only works if booking is faster than flagging down an auto in person.

Sketched the student journey the deck would promise: pick pickup and drop, pick number of seats, see what's available right now, book, pay. Kept it to a single linear flow with no account setup friction.
Made the case for restricting sign-in to @thapar.edu accounts via Google so the rider base stays students and there is no separate password system to build or secure.
Argued for two clearly separated roles from the start — student and driver — rather than one app trying to be both, since their screens and needs barely overlap.

## Week 2 — Project Proposal

Wrote the frontend section of the proposal and locked the client stack.

Specified Flutter for a single codebase across Android and web, with Provider for state, http for the API, and shared_preferences to persist the session so a returning user lands straight in their role instead of the role picker.
Chose Firebase Auth with Google Sign-In for identity, and documented that the backend still independently checks the @thapar.edu domain on student creation — the client restriction is convenience, the server restriction is the actual rule.
Planned the screen inventory: a role-select screen, student login/home/trip-status/payment screens, and driver login/dashboard screens, plus shared widgets (location dropdown, seat selector, primary button) so the two roles stay visually consistent.
Made a scope cut: no push notifications in this stage. Trip status is checked by pulling from the API when the student opens the status screen, documented as a deliberate simplification rather than a missing feature.

## Week 3 — Student Booking Flow and Live Availability

Built the end-to-end student path from stop selection through to a confirmed booking.

### Booking screen

Built the home screen around the location dropdown and seat selector widgets, loading the fixed stop list from the /locations endpoint so the ordering always matches what the backend uses for direction.
Wired the availability preview: as soon as pickup, drop, and seat count are set, the screen calls /availability and shows the student both the enroute autos they could pool onto (with remaining seats each) and whether a fresh auto is available — without committing to anything yet.
Guarded the obvious bad input on the client — same pickup and drop, zero seats — so the student sees an inline message instead of a raw backend error, while leaving the backend validation in place as the real gate.

### Trip status and payment

Built the trip-status screen to show whether the booking was pooled onto an existing auto or dispatched fresh, using the pooled flag the booking response returns, so the student understands why another rider might already be aboard.
Built the payment screen around the driver's uploaded UPI QR image served from the backend, plus the flat fare (seats times the per-seat rate) read straight from the booking, and marked payment as pending until confirmed rather than assuming success.
Centralized every network call in a single api_service so base URL and error handling live in one place, after an early version had endpoint strings scattered across screens that broke when the API host changed.

## Week 4 — Activity Diagram and Sequence Diagram (Student Booking Flow)

Split the week between modeling the student's screen-by-screen decision path as an activity diagram and modeling the api_service calls underneath it as a sequence diagram.

### Activity diagram

Modeled the flow from sign-in through to a confirmed booking as a single activity diagram, with the two client-side guard rails from Week 3 (same pickup/drop, zero seats) drawn as an explicit decision node before the availability call, rather than folded into a generic "validate input" step, since that's the actual gate the student hits before anything reaches the backend.
Branched the diagram on pooled-vs-fresh right after the booking request, matching how the trip-status screen reads the pooled flag, so the diagram reflects that the two outcomes lead to different messaging but the same payment screen afterward.
Left push notifications out of the diagram entirely rather than showing a dead-end branch for them, consistent with the Week 2 scope cut — a diagram showing an unreachable branch would misrepresent what the app actually does.
Caught one gap on review: an early draft started the flow at stop selection and skipped how the location dropdown gets populated. Added a step at the front of the flow to reflect that the stop list is pulled from the backend before the student can select anything, matching Week 3's implementation.

### Sequence diagram

Modeled every call the centralized api_service makes across the booking-to-payment path, in the order the student actually triggers them: locations on screen load, availability on input change, booking on confirm, and a payment-status update on the payment screen.
Kept api_service as its own lane separate from the UI, rather than showing screens calling the backend directly, since that's the whole reason Week 3 centralized network calls into one place — the diagram should show that boundary, not hide it.
Cross-checked the booking and payment-status calls against Trijal's sequence diagram of the backend transaction afterward, to make sure the field names on the booking response (pooled flag, fare, QR URL) matched exactly on both sides.
