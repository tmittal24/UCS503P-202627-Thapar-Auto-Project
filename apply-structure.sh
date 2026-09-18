#!/usr/bin/env bash
# Run this from the ROOT of your repo clone, after copying in
# mkdocs.yml, README.md and docs/index.md.
set -e

# 1. Journals must be folders containing index.md for the nav to resolve them.
cd journals
for f in *; do
  if [ -f "$f" ]; then
    mkdir -p "$f.dir" && mv "$f" "$f.dir/index.md" && mv "$f.dir" "$f"
  fi
done
cd ..

# 2. Fix the double extension so the design doc's image link resolves.
[ -f docs/activity_diagram.jpg.jpeg ] && mv docs/activity_diagram.jpg.jpeg docs/activity_diagram.jpg

# 3. Remove the space from the proposal filename (spaces break the URL).
[ -f "project-proposal/thapar_auto_proposal .pdf" ] && \
  mv "project-proposal/thapar_auto_proposal .pdf" "project-proposal/thapar_auto_proposal.pdf"

# 4. Expose the proposal folder to the site (same trick as docs/assets).
ln -sfn ../project-proposal docs/project-proposal

echo "Done. Now: git add -A && git commit -m 'Build project docs site' && git push"
