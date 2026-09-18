<p align="center">
  <b>UCS503: Software Engineering (Project)</b><br/>
  Thapar Institute of Engineering & Technology, Patiala
</p>

# Thapar Auto: Shared Campus Auto-Rickshaw System

***A Stop-Ordered Ride Pooling, Dispatch & UPI Settlement Platform***

[![Frontend](https://img.shields.io/badge/Frontend-Flutter%20%2F%20Dart-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2F%20Express-339933?style=flat-square&logo=nodedotjs&logoColor=white)](https://expressjs.com/)
[![Database](https://img.shields.io/badge/Database-SQLite-003B57?style=flat-square&logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Docs](https://img.shields.io/badge/Docs-MkDocs%20%2F%20LaTeX-008080?style=flat-square)](https://www.mkdocs.org/)

📖 **Project Site:** [tmittal24.github.io/UCS503P-202627-Thapar-Auto-Project](https://tmittal24.github.io/UCS503P-202627-Thapar-Auto-Project)

---

## Overview

Students waiting at campus auto stops have no way of knowing when the next auto will
arrive or whether it will have room. Autos leave half-empty on some routes while students
overflow on others, and fares are negotiated ad hoc with no fixed rate.

Thapar Auto treats an in-progress trip as a joinable resource. A student picks a pickup
stop, a drop stop, and a seat count; the system first searches for an auto already enroute
in the same direction with spare seats, and only dispatches a fresh auto from a cyclic idle
queue when nothing poolable fits. Drivers register once with their vehicle and UPI QR code,
then run trips from a dashboard showing queue position, current riders, and trip completion.

## Team

| Role | Team Member | Roll Number |
| :--- | :--- | :--- |
| Backend Architect & Matching Engine Lead | Trijal | `1024030784` |
| Frontend Architect & Student Flow Lead | Tushit | `1024031079` |
| Driver Systems & Trip Lifecycle Lead | Arpita | `1024030778` |

## Tech Stack

- **Frontend:** Flutter (Android + Web), Provider, `shared_preferences`
- **Auth:** Firebase Auth + Google Sign-In, restricted to `@thapar.edu`
- **Backend:** Node.js + Express, `multer` for QR uploads
- **Database:** SQLite via `better-sqlite3`

## Repository Layout

| Path | Contents |
| :--- | :--- |
| [`code/`](code) | Application source — `backend/` (Express API) and `frontend/` (Flutter app) |
| [`docs/`](docs) | System design diagrams and the MkDocs source for the project site |
| [`journals/`](journals) | Weekly engineering journals, one folder per team member |
| [`project-proposal/`](project-proposal) | LaTeX project proposal and compiled PDF |
| [`project-report-prototype-stage/`](project-report-prototype-stage) | Prototype-stage evaluation report |
| [`project-report-final/`](project-report-final) | Final project report |

## Running Locally

**Backend**

```bash
cd code/backend
npm install
npm start
```

**Frontend**

```bash
cd code/frontend
flutter pub get
flutter run
```

Firebase credentials (`google-services.json`) are excluded from version control and must be
supplied locally for Google Sign-In to work.

## Documentation Site

`docs/` is built with [MkDocs](https://www.mkdocs.org/) using the Material theme. Any push to
`master` triggers `.github/workflows/mkdocs.yml`, which runs `mkdocs gh-deploy` and publishes
to the `gh-pages` branch. Ensure **Settings → Pages → Source** is set to `gh-pages` / `(root)`.

Local preview:

```bash
pip install mkdocs mkdocs-material mkdocs-material-extensions mkdocstrings \
  mkdocstrings-python mkdocs-gen-files mkdocs-literate-nav mkdocs-section-index \
  mkdocs-click mkdocs-git-revision-date-localized-plugin \
  mkdocs-git-committers-plugin-2 mkdocs-git-authors-plugin pymdown-extensions

mkdocs serve
```
