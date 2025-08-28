# QualitySim — SPC + Acceptance Sampling Sandbox

A single-file, browser-only simulation app for **Quality Engineering** courses.  
Students can explore **process capability (Cpk/Ppk, DPMO)**, **SPC (X̄ chart)**, **acceptance sampling (OC curve, AOQ)**, **gage error**, **assignable causes**, **drift**, and **cost trade-offs**—no installs needed. Built with **HTML + vanilla JS + Chart.js** and deployable via **GitHub Pages**.

**Live site:** _(Add after enabling Pages)_ → `https://<username>.github.io/<repo>/`

---

## Features

- Monte Carlo process model with **LSL/USL, μ, σ, drift, assignable causes**
- **X̄ control chart** with CL/UCL/LCL and optional automatic resets
- **Single-sampling plan (n, c)** with **OC curve** and **AOQ**
- **Gage measurement error** (σ as % of tolerance)
- **KPIs:** DPMO, Cpk, % lots accepted, AOQ, cost/unit, SPC resets
- **Histogram** of produced items; CSV export of summary + X̄ points

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

1. Click **Run simulation** with defaults; record **DPMO, Cpk, % accepted, AOQ, cost/unit**  
2. Change **gage %Tol**, **(n, c)**, **assignable cause prob**/**shift**, **σ**, and **drift**; observe SPC resets, OC curve, AOQ, and cost impacts  
3. Download CSV to analyze X̄ series and KPIs

---

## Suggested Exercises

- **Capability vs inspection:** lower σ vs higher n; compare AOQ and cost/unit  
- **Effect of gage error:** increase %Tol and discuss escapes vs rejections  
- **SPC on/off:** compare AOQ and escapes when assignable causes are frequent  
- **Plan selection:** compare (n, c) plans using OC + AOQ + cost

---

## Prompt-Engineering Upgrade Ideas

- Add **Western Electric rules** to X̄ and count violations  
- Add an **R chart** (D3 factors)  
- Implement **double sampling** (n₁, c₁, n₂, c₂) and update OC curve  
- Track **Taguchi loss** \( L(x)=k(x−m)^2 \)  
- Show a **Gage R&R ndc** indicator  
- Add **replications (K)** to report mean ± 95% CI for KPIs

(Each change can be requested from an LLM with a precise prompt: name the file `index.html`, where to insert code, and acceptance criteria.)

---

## Tech Stack

- **Chart.js** via CDN, no build step  
- **Vanilla JS** (no dependencies)  
- Works on any modern browser

---

## License

MIT — use in courses freely; attribution appreciated.
