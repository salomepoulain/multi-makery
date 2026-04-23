# 🥨 multi-makery

> A modular recipe-book system for your project's development environment.

`multi-makery` is a declarative scaffolding system powered by Make. Instead of copying Makefiles between projects, you hire specialized **Stations** to set up environments and run tasks. Think of it as a package manager for boilerplate with personality.

---

## The Bakery Metaphor

- `.makery` is a tiny bakery that lives in your repository.
- The **Head Chef** (`.makery/headchef`) is the main orchestrator.
- **Stations** are workspaces where specialized **Dishes** get baked — each Station focuses on one kind of action and brings its own dependencies.
- You **order Dishes** from the menu with `bake`.

When you order a new Dish (`first <name>`)
- The Head Chef hires the appropriate Station.
- The Station checks its dependencies and sets itself up.
- At hire time the Station runs its start contract (for example, creating a `.venv` for Python) so common setup happens automatically.

Cleaning and refreshing
- If a Station caches files, wash it with `bake fresh <name>`.
- `bake germs` cleans all workbenches (kitchen-wide).
- `bake burnt <name>` fires the Station and runs its stop script to undo leftovers.

Hidden workspace
- `.makery` is hidden from git by default.
- `.contraband` lists files and paths to keep out of version control.

---

## Getting Started

### Option 1: Install with `bake` (global, recommended)

Install the `bake` command once per machine:
```bash
curl -sSL https://raw.githubusercontent.com/salomepoulain/multi-makery/main/office/install_makery.sh -o install_makery.sh
sha256sum install_makery.sh
bash install_makery.sh
```
This installs `bake` to `~/.local/bin` and the engine to `~/.makery`.

Then in a new project folder:
```bash
bake
```
`bake` detects the missing kitchen and runs `open_makery.sh` to create `.makery` and a local `Makefile`.

### Option 2: Use `make` only (no global install)

If you don't want to install `bake` globally, you can set up a single project manually:

```bash
# 1. Clone multi-makery into your project (or download the files)
git clone --depth 1 https://github.com/salomepoulain/multi-makery.git .makery-temp

# 2. Set up the kitchen manually
bash .makery-temp/office/open_makery.sh

# 3. Clean up
rm -rf .makery-temp
```

Now you can use `make` directly:
```bash
make first s=python    # Hire the python station
make git-public       # Run a skill (same as `bake git public`)
make fresh s=python   # Clean the python workbench
make germs            # Clean all workbenches
make burnt s=python   # Fire the python station
```

**Note:** Without `bake`, you lose hyphen-stitching (`bake git public` → `make git-public`) and auto-initialization, but all core functionality works with `make` directly.

---

## Core Commands (customer-facing)

- `bake` — Initialize the kitchen in the current folder.
- `bake first <name>` — Hire a Station and run its onboarding.
- `bake fresh <name>` — Force a Station to scrub its workspace.
- `bake burnt <name>` — Fire a Station and undo its leftovers.
- `bake germs` — Kitchen-wide cleanup of all workbenches.
- `bake all` — Fire all Stations and remove `.makery`.
- `bake inspo` — List available Stations/dishes from the registry.

**Note:** The global `bake` command supports hyphen-stitched names (`bake git public`) as well as direct Make targets (`make git-public`) for compatibility.

---

## Bake vs. Make

The `bake` command is a convenience wrapper around `make`. The core functionality lives in the `Makefile` and `.makery/kitchen/headchef/menu.mk`:

- **With `bake`**: You get hyphen-stitching (`bake git public` → `make git-public`), auto-initialization, and the nice CLI UX.
- **With `make` directly**: Works too! Use `make first s=python` or `make git-public` — the `Makefile` includes all the headchef and station menus automatically.

Most users will prefer `bake` for the convenience, but `make` works as a fallback.

---

## Available Dishes (station structure)

A Station is organized like this:

```
station-name/
├── menu.mk            # Maps bake commands to scripts (first, fresh, burnt)
├── cook/
│   ├── start.sh       # Runs when the Station is hired
│   ├── quit.sh       # Runs when the Station is fired
│   ├── .prerequisite # Required system tools (e.g., gh, python)
│   └── personality.sh # Optional messages/theme
├── skills/            # Actions the Station knows
│   ├── setup.sh       # Example: prepare environment
│   └── deploy.sh      # Example: deploy a package
└── workbench/
    ├── .contraband    # Rules appended to project .gitignore
    └── .dishsoap      # Paths/caches cleaned by `bake fresh`
```

Published reference: `salomepoulain/makery-stations`.

---

## Creating New Stations

Stations live in a registry (default: `salomepoulain/makery-stations`). Each Station declares its prerequisite tools and provides:
- `start.sh` for onboarding,
- `menu.mk` mapping human-friendly names to scripts,
- modular `skills/` files for individual actions,
- a `workbench/` with `.contraband` and `.dishsoap` for hygiene and cleanup.

---

## Security and Reproducibility

- Verify the installer hash or signature before running.
- Prefer package managers (e.g., Homebrew) when available.
- Do not run remote scripts without review.
- For reproducible installs, pin the release tag and verify checksums or Git commit signatures.

---

## Installation — Verified Releases

Each release publishes:
- `multi-makery-<tag>.tar.gz` — source tarball
- `multi-makery-<tag>.tar.gz.sha256` — SHA256 checksums
- Optional GPG signature `.asc`

Verify example:
```bash
curl -sSL -o multi-makery-v0.1.0.tar.gz \
  https://github.com/salomepoulain/multi-makery/releases/download/v0.1.0/multi-makery-v0.1.0.tar.gz
sha256sum -c <<< "$(grep multi-makery-v0.1.0.tar.gz multi-makery-v0.1.0.tar.gz.sha256)"
gpg --verify multi-makery-v0.1.0.tar.gz.asc
```
The installer automatically downloads and verifies the checksum from the release assets.

---

## Contributing

To add a Station:
1. Follow the Station template.
2. Publish to the registry (e.g., `salomepoulain/makery-stations`).
3. Update the changelog and create a signed Git tag for the release.
