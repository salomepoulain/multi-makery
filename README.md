# 🥨 multi-makery

> **The modular recipe book for your project's development environment.**

`multi-makery` is a declarative project scaffolding system powered by Make. Instead of copy-pasting monolithic Makefiles between projects, you hire specialized **Line Cooks** to set up their **Stations** in your project. It’s like a package manager for your boilerplate, but with a lot more personality.

---

## The Bakery Metaphor

To understand `multi-makery`, you have to understand how the kitchen is organized:

* **The Kitchen**: Your project directory.
* **The Head Chef (`.makery/headchef`)**: The core engine that handles hiring, firing, and overall management.
* **Line Cooks (`cook/`)**: The active logic. They set up environments, install dependencies, and run scripts.
* **Skills (`skills/`)**: Specialized scripts a cook knows how to perform (e.g., `git-public`, `python-deploy`).
* **The Menu (`menu.mk`)**: Every cook brings a menu of skills which are automatically integrated into your project's master menu.

---

## Getting Started

### 1. The Global License (System Install)
To use the `bake` command anywhere on your system, run the global installer. This only needs to be done **once**.

```bash
curl -sSL [https://raw.githubusercontent.com/salomepoulain/multi-makery/main/install_makery.sh](https://raw.githubusercontent.com/salomepoulain/multi-makery/main/install_makery.sh) | bash
```
*This installs `bake` to `~/.local/bin` and stores the engine in `~/.makery`.*

### 2. Open a Kitchen (Project Initialization)
In a new, empty project folder, simply type:
```bash
bake
```
*Because the `bake` command is global, it detects the absence of a kitchen and automatically runs `open_makery.sh` to build your local `.makery` folder and `Makefile`.*

---

## Bake vs. Make: What's the difference?

`multi-makery` is designed to be "Make-native" but "Bake-enhanced."

| Feature | `bake` (Global CLI) | `make` (Local Fallback) |
| :--- | :--- | :--- |
| **Setup** | Installed once per computer. | Lives inside each project. |
| **Syntax** | `bake first python` | `make first s=python` |
| **Routing** | Smart routing: `bake git public` | Standard: `make git-public` |
| **Auto-Init** | Runs `open_makery` automatically. | Requires manual script execution. |

---

## Basic Training (Workflow)

### 1. Hire a Cook
Need version control? Call the agency:
```bash
bake first git
```
*The Head Chef fetches the Git station from the registry, initializes your repo, and creates your GitHub remote.*

### 2. Read the Menu
See what your hired cooks can do:
```bash
bake menu
```

### 3. Use a Skill
Run a specific action from a cook's menu:
```bash
bake git public
```
*The `bake` command intelligently maps this to the `git-public` target in your Makefile.*

### 4. Clean the Kitchen
Remove the temporary mess (logs, caches, etc.) from all stations:
```bash
bake germs
```

---

## The Head Chef's Orders (Command Reference)

| Command | Action | Description |
| :--- | :--- | :--- |
| `bake` | **Initialize** | Runs `open_makery.sh` to build a kitchen in the current folder. |
| `bake first <name>` | **Hire** | Downloads a station and runs the cook's onboarding script. |
| `bake burnt <name>` | **Fire** | Tears down a station and deletes its files. |
| `bake germs` | **Deep Clean** | Scrubs every workbench (removes local build artifacts). |
| `bake fresh <name>` | **Scrub** | Forces a specific cook to scrub their workbench. |
| `bake all` | **Explode** | Fires everyone and deletes the entire `.makery` folder. |

---

## Inventing New Dishes (Creating Stations)

Stations are hosted in your Registry (default: `salomepoulain/makery-stations`). A station directory looks like this:

```text
git/
├── menu.mk            # Maps bake commands to skill scripts
├── cook/
│   ├── start.sh       # Onboarding logic (runs during 'first')
│   ├── .prerequisite  # Required system tools (e.g., 'gh')
│   └── personality.sh # Cook's color and dialogue
├── skills/
│   ├── public.sh      # Individual skill logic
│   └── private.sh
└── workbench/
    ├── .contraband    # Rules to append to project .gitignore
    └── .dishsoap      # Paths to delete during 'germs'
```

---

## Advanced Features

* **Two-Repo System**: The **Engine** (`multi-makery`) is separate from the **Registry** (`makery-stations`).
* **Hyphen-Stitching**: The global `bake` command allows you to use spaces instead of hyphens for a more modern CLI feel (`bake git public` vs `make git-public`).
* **Contraband Protection**: The workbench automatically handles your `.gitignore` so you never leak secrets or heavy dependencies.
