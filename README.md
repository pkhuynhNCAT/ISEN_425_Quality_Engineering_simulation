# TURBO STREET RACERS — QA Bug Hunt Edition

A single-file, browser-only **arcade racing game** for classroom use.
Students play a neon overhead racer with **traffic, nitro, coins, cones, and police chase**, then identify **deliberately planted flaws** and fix them using **prompt engineering**—no installs needed. Built with **HTML + vanilla JS (Canvas)** and deployable via **GitHub Pages**.

**Live site:** `https://pkhuynhncat.github.io/ISEN_425_Quality_Engineering_simulation/`

---

## Features

* Fast overhead racer: lanes, coins, cones, traffic, **nitro boost**, and a police “catch” bar
* **Missions panel (M)** and **export CSV** for quick evidence of changes
* Built-in, clearly tagged issues (`// ANTI-PATTERN`, `// FIXME`) for students to find and fix
* **Score/Hits/Timer** HUD; screen shake and simple SFX (toggleable)
* **Single-file app (`index.html`)** — no build step, no dependencies

---

## Quick Start

1. Download `index.html` (already in this repo)
2. Open it directly in a browser — or deploy to GitHub Pages (below)

### Deploy to GitHub Pages (free)

1. Push to `main` (or `master`)
2. In **Settings → Pages**, set **Source** to “Deploy from a branch”, Branch = your default, **/ (root)**
3. Save; wait for the URL to appear, then add it to the repo’s **About → Website** field

---

## How to Use (students)

1. Click **Play**, then drive: **←/→ or A/D** (steer), **↑/↓ or W/S** (throttle), **Space** (nitro), **P** (pause), **M** (missions)
2. While playing, note anything that feels off (lag, unfair spawns, loud SFX, etc.)
3. Open the code in `index.html`, search for tags like `// ANTI-PATTERN #...`, and fix them using prompt-engineered diffs
4. Use **Export CSV** to capture before/after evidence (e.g., score doesn’t change during pause)

---

## Suggested Exercises

* **Steering responsiveness:** remove input lag so lane changes feel immediate
* **Fair spawns:** enforce a minimum distance from the player and reduce clumping
* **Real pause:** freeze spawners, timers, and score while paused
* **Nitro balance:** shorten duration and reduce boost to a fair level
* **Collision accuracy:** tighten the player hitbox to match the car sprite

---

## Prompt-Engineering Upgrade Ideas

* Uncap FPS and use real `dt` in the main loop
* Respect the **SFX** checkbox and reduce default volume
* Cap and prune **particles** to prevent slowdowns
* Wire up **mobile touch controls** (steer/throttle/nitro)
* Add an **accessibility mode** (shapes/outline cues, not just color)
* Tune **police rubberbanding** for fair chase/escape dynamics

(Each change can be requested from an LLM with a precise prompt: name the file `index.html`, point to the exact function/variable, specify target values, and state acceptance criteria. Ask for a unified diff of only changed lines.)

---

## Tech Stack

* **Vanilla JS (Canvas)**, no external libraries
* **Single HTML file** (inline CSS/JS)
* Works on any modern browser

---

## License

MIT — use in courses freely; attribution appreciated.
