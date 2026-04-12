# multi-makery 🥐 

> **The modular recipe book for your project's development environment.**

`multi-makery` is a declarative project scaffolding system powered by Make. Instead of copy-pasting monolithic Makefiles between projects, you hire specialized **Line Cooks** to set up their **Stations** in your project. It’s like a package manager for your boilerplate, but with a lot more personality.

---

## 🥖 The Bakery Metaphor

To understand `multi-makery`, you have to understand how the kitchen is organized:

*   **The Kitchen**: Your project directory.
*   **The Head Chef (`.makery/headchef`)**: The core engine. The Head Chef handles the hiring, firing, and overall management of the project.
*   **Line Cooks (`cook/`)**: The active logic of a module. The person who arrived to set up the environment, install dependencies, and run commands.
*   **The Workbench (`workbench/`)**: The physical workspace of a cook. This is where they hide their **Contraband** (Git-ignored files), keep their **Dishsoap** (cleaning instructions), and store their **Pantry** (static templates).
*   **The Menu (`menu.mk`)**: Every cook brings their own menu of skills (e.g., `python-serve`, `git-yolo`) which are automatically added to your project's master menu.

---

## 🚀 Getting Started

You can use `multi-makery` in two ways: the **Global CLI** (recommended) or the **Local Makefile**.

### The Global Headquarters (Highly Recommended)
Install the `bake` command globally on your system to enjoy the sleekest experience.

```bash
bash <(curl -s https://raw.githubusercontent.com/salomepoulain/multi-makery/main/office/open_makery.sh) bake
```
*This adds `bake` to your system path. You can now use it in any folder.*

### The Local Startup
If you prefer not to install anything globally, you can just set up a local kitchen:
```bash
bash <(curl -s https://raw.githubusercontent.com/salomepoulain/multi-makery/main/office/open_makery.sh) make
```

---

## 📦 Basic Training (Workflow)

### 1. Lay the Foundation
In a new, empty project folder, run:
```bash
bake concrete
```
*This downloads the Head Chef and builds your local `.makery` folder and `Makefile`.*

### 2. Hire a Cook
Need Python? Call the agency:
```bash
bake first python
```
*The Head Chef fetches the Python station, the cook arrives, sets up a `.venv`, and hides it from the Health Inspector (Git).*

### 3. Read the Menu
See what your hired cooks can do:
```bash
bake menu
```

### 4. Clean the Kitchen
Remove the temporary mess (logs, caches, etc.) from all stations:
```bash
bake germs
```

---

## 🛠️ The Head Chef's Orders (Command Reference)

| Command | Action | Description |
| :--- | :--- | :--- |
| `bake concrete` | **Initialize** | Lays the foundation of the Makery in a new project. |
| `bake first <name>` | **Hire** | Downloads a station and runs the cook's onboarding script. |
| `bake burnt <name>` | **Fire** | Tears down a station, purges system changes, and deletes the module. |
| `bake inspo` | **List** | Lists all line cooks currently available at the recruitment agency. |
| `bake germs` | **Deep Clean** | Scrubs every workbench in the kitchen (removes local build artifacts). |
| `bake fresh <name>` | **Scrub** | Forces a specific cook to scrub their workbench. |
| `bake all` | **Explode** | Fires everyone and deletes the entire `.makery` folder. Use with caution! |

> **Note:** If you are using the local `make` fallback, the syntax is `make first s=python`.

---

## 👨‍🍳 Inventing New Dishes (Creating Stations)

Stations are hosted in a separate registry repository (default: `salomepoulain/makery-stations`). A station directory looks like this:

```text
python/
├── menu.mk              # Make targets (e.g., python-serve:)
├── cook/
│   ├── start.sh         # Onboarding script (runs during 'first')
│   ├── quit.sh          # Teardown script (runs during 'burnt')
│   ├── personality.sh   # Defines terminal color and dialogue
│   └── .prerequisite    # Required system tools (e.g., 'uv')
└── workbench/
    ├── .contraband      # Rules to append to project .gitignore
    ├── .dishsoap        # Paths to delete during 'germs'
    └── pantry/          # Static files to copy to project root
```

---

## 🧪 Advanced Features

*   **Two-Repo System**: The **Engine** (`multi-makery`) is separate from the **Registry** (`makery-stations`). This allows you to fork the engine or create your own private registries.
*   **Personalities**: Cooks speak in their own colored uniforms! Customize `personality.sh` to give your cooks unique voices.
*   **Contraband Protection**: Never accidentally commit a `.venv` again. The workbench handles your `.gitignore` automatically.
