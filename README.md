# 🥨 multi-makery

> A modular recipe-book system for your project's development environment.

`multi-makery` is a declarative scaffolding system powered by Make. Instead of copying Makefiles between projects, you hire specialized **Stations** to set up environments and run tasks. Think of it as a package manager for boilerplate with personality.

---

## The Bakery Metaphor

- `.makery` is a tiny bakery that lives in your repository.
- The **Head Chef** (`.makery/kitchen/headchef`) is the main orchestrator.
- **Stations** are workspaces where specialized **Skills** get baked — each Station focuses on one kind of action and brings its own dependencies.
- You **order Skills** from the menu with `bake`.

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

**One-liner (quick):**
```bash
curl -sSL https://raw.githubusercontent.com/salomepoulain/multi-makery/main/office/install_makery.sh | bash
```

**Step-by-step (verify hash first):**
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
make first s=python       # Hire the python station
make call s=python d=test  # Run a dish from a station
make fresh s=python       # Clean the python workbench
make germs                # Clean all workbenches
make burnt s=python       # Fire the python station
```

**Note:** Without `bake`, you lose auto-initialization and the simplified routing, but all core functionality works with `make` directly.

---


## Core Commands (customer-facing)

- `bake` — Initialize the kitchen in the current folder.
- `bake first <name>` — Hire a Station and run its onboarding.
- `bake fresh <name>` — Force a Station to scrub its workspace.
- `bake burnt <name>` — Fire a Station and undo its leftovers.
- `bake germs` — Kitchen-wide cleanup of all workbenches.
- `bake all` — Fire all Stations and remove `.makery`.
- `bake inspo` — List available Stations/dishes from the registry.

**Note:** The bake command routes commands automatically — core operations take a station name (e.g., `bake first python`), while station dishes use the `call` target (e.g., `bake python test` → `make call s=python d=test`).

---

## Bake vs. Make

The `bake` command is a convenience wrapper around `make`. The core functionality lives in the `Makefile` and `.makery/kitchen/headchef/menu.mk`:

- **With `bake`**: Auto-initialization and the nice CLI UX. The bake script tries `make $1 s=$2` first, falling back to `make call s=$1 d=$2` for station dishes.
  - `bake first python` → `make first s=python` (core commands)
  - `bake python test` → `make call s=python d=test` (station dishes)
- **With `make` directly**: Works too! Use `make first s=python` or `make call s=python d=test` — the `Makefile` includes all the headchef and station menus automatically.

Most users will prefer `bake` for the convenience, but `make` works as a fallback.

---

## Available Skills (station structure)

A Station is a regular Makefile with explicit targets and comments. It works standalone — just `cd` to the station directory and run `make <skill>`.

```
station-name/
├── menu.mk                  # Makefile with menu:: and skill targets
├── cook/
│   ├── personality.sh       # Cook identity (icon, name, color)
│   ├── contract/
│   │   ├── .prerequisite    # Required system tools (e.g., python, node)
│   │   ├── hired.sh         # Runs once when the Station is hired
│   │   └── fired.sh         # Runs once when the Station is fired
│   └── skills/
│       ├── example.sh       # Example skill (bake call s=<name> d=example)
│       └── custom.sh        # Custom skill
└── workbench/
    ├── pantry/              # Static files copied to project root on hire
    ├── .contraband          # Entries appended to .gitignore
    └── .dishsoap            # Paths/caches deleted by `bake fresh`
```

Published reference: `salomepoulain/makery-stations`.

---

## Creating New Stations

Stations live in a registry (default: `salomepoulain/makery-stations`). Use the template in `office/station-template/` to create new Stations.

### Writing a Station `menu.mk`

Write a regular Makefile with a `menu::` double-colon target and your skill targets. The lifecycle scripts (`hired.sh`, `fired.sh`) are run directly by the Head Chef — they don't belong as Make targets in `menu.mk`.

```makefile
# station-name/menu.mk
# Standalone Makefile — works with: cd .makery/kitchen/stations/<name> && make <skill>

# Skills defined below are run via: bake call s=<station> d=<skill>
# (first, fresh, burnt are managed by the Head Chef)

menu::
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  my-station Station"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  STATION SKILLS"
	@echo "    bake my-station example    Run the example skill"
	@echo ""

# example: Run an example task
example:
	@bash cook/skills/example.sh
```

The `menu::` double-colon rule appends to the Head Chef's `menu::` — so `bake menu` shows your station's section after the core operations. Replace `my-station` with your actual station name and list all your skills in the echo block.

The headchef provides a `call` target that routes to stations. Use `make call s=<station> d=<skill>` or let `bake` handle routing automatically.

### Station structure requirements

Each Station provides:
- `menu.mk` (copy from `office/station-template/menu.mk`, update the station name, and add skill targets),
- `cook/contract/hired.sh` and `cook/contract/fired.sh` for setup and teardown,
- `cook/contract/.prerequisite` listing required system tools,
- `cook/skills/` for skill scripts,
- a `workbench/` with `.contraband`, `.dishsoap`, and optionally `pantry/` for static files.

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

---

## Development Setup

### Pre-commit hooks

We use the [pre-commit](https://pre-commit.com/) framework to lint shell scripts before commit:

```bash
# One-time setup
pip install pre-commit
pre-commit install

# Install shellcheck (if not already installed)
# macOS: brew install shellcheck
# Ubuntu: sudo apt install shellcheck
```

The `.pre-commit-config.yaml` runs `shellcheck` on all `*.sh` files staged for commit.

### CI Safety Net

The GitHub Actions workflow (`.github/workflows/test.yml`) also runs shellcheck on every push to `main` and on PRs — this catches anything that slipped past the pre-commit hook.
