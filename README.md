# AVCA

An AI-powered investment management tool for venture teams. It does two things:

1. **Portfolio Tracking** — Drop quarterly updates (PDFs, Excel, PPTs) into company folders. Claude extracts financials, flags risks, tracks promises, and produces structured dashboards your team can act on.

2. **Deal Flow Management** — Drop pitch decks into the Deal Flow folder. Claude scores each pitch on a 100-point rubric, ranks them by priority, and produces a single evaluation dashboard. When you invest, the company graduates to your portfolio.

Both workflows run locally. All company data stays on your machine — nothing is sent over the network.

## Quick Start

### Portfolio Tracking

1. **Clone this repo**
   ```bash
   git clone <repo-url>
   cd AVCA
   ```

2. **Create a folder for each portfolio company**
   ```
   mkdir "Fintech - Acme Payments"
   mkdir "Climate - GreenCo"
   ```
   Folder format: `{Sector} - {Company Name}/`

3. **Drop update files into the company folder**
   - PDFs (investor updates, board decks)
   - Excel files (MIS, P&L, KPIs)
   - PowerPoint files (quarterly presentations)

4. **Run Claude Code in this directory**
   ```bash
   claude
   ```
   Then say: *"Process the new updates"*

5. **Open the HTML outputs in your browser**
   - `Claude Summary/Portfolio Dashboard.html` — one-page portfolio view
   - `Claude Summary/Red Flags & Follow-ups.html` — action items and warnings
   - `Claude Summary/Promise Tracker.html` — company accountability dashboard
   - `Claude Summary/Collaboration Opportunities.html` — cross-portfolio synergies
   - `Claude Summary/Team Update - {Month} {Year}.html` — shareable team summary

### Deal Flow Management

1. **Create a folder for the pitch inside `Deal Flow/`**
   ```
   mkdir -p "Deal Flow/Fintech - NovaPay"
   mkdir -p "Deal Flow/Climate - GreenGrid"
   ```

2. **Drop pitch documents into the folder** — decks, one-pagers, financial models

3. **Run Claude Code** and say: *"Evaluate the new pitches"*

4. **Open the output:** `Claude Summary/Deal Flow.html` — ranked prioritization dashboard

## What You Get

### Portfolio Tracking Outputs

| Output | Format | Purpose |
|--------|--------|---------|
| **Portfolio Dashboard** | HTML | One-page view of all companies — health, revenue, burn, signals |
| **Red Flags & Follow-ups** | HTML | Urgent items, financial warnings, positive signals |
| **Promise Tracker** | HTML | Accountability dashboard — tracks company commitments and delivery rates |
| **Collaboration Opportunities** | HTML | Cross-portfolio synergies and value creation opportunities (externally shareable) |
| **Running Summary** | Markdown | Detailed per-company analysis with financials, metrics, signals |
| **Team Update** | HTML | Shareable summary — one card per company, designed for team distribution |
| **Monthly Report** | Markdown | End-of-month compilation for the investment team |

### Deal Flow Outputs

| Output | Format | Purpose |
|--------|--------|---------|
| **Deal Flow Dashboard** | HTML | Pitch evaluation & prioritization — scores pitches on a 100-point rubric, ranked by priority tier |

## How It Works

Claude reads the `CLAUDE.md` file in this repo for all its instructions. When you start a Claude Code session in this directory, it knows how to handle both workflows.

### Portfolio Processing Flow

```
Drop files into company folder
        ↓
Run Claude → detects new files
        ↓
Processes ONE company at a time
        ↓
Updates 5 files: Running Summary + Dashboard + Red Flags + Promise Tracker + Collaboration Opportunities
        ↓
Asks which company to process next
        ↓
After all companies → generates Team Update
```

### Pitch Evaluation Flow

```
Drop pitch docs into Deal Flow/{Sector} - {Company}/
        ↓
Run Claude → detects new pitches
        ↓
Evaluates ONE pitch at a time (100-point rubric: Team, Market, Traction, Product, Business Model, Deal Terms)
        ↓
Updates Deal Flow.html (pitch card + comparison table + sector distribution)
        ↓
Asks which pitch to evaluate next
        ↓
If invested → company graduates to portfolio tracking
```

### Detecting New Files

Run the detection script to see what hasn't been processed yet. It scans both portfolio folders and Deal Flow in separate passes:

```bash
bash detect_new_files.sh
```

## Folder Structure

```
AVCA/
├── README.md                         ← You are here
├── CLAUDE.md                         ← Instructions for Claude (don't delete this)
├── detect_new_files.sh               ← Script to find unprocessed files
│
├── Claude Summary/                   ← All Claude-generated outputs
│   ├── Portfolio Dashboard.html      ← Portfolio tracking
│   ├── Red Flags & Follow-ups.html   ← Portfolio tracking
│   ├── Promise Tracker.html          ← Portfolio tracking
│   ├── Collaboration Opportunities.html ← Portfolio tracking
│   ├── Deal Flow.html                ← Deal flow management
│   ├── Team Update - Feb 2026.html   ← Portfolio tracking
│   ├── Running Summary.md            ← Portfolio tracking
│   └── Monthly Report - Feb 2026.md  ← Portfolio tracking
│
├── Deal Flow/                        ← Incoming pitches (deal flow)
│   ├── README.md
│   ├── Fintech - NovaPay/
│   │   └── Series A Deck.pdf
│   └── Climate - GreenGrid/
│       └── Pitch Deck.pdf
│
├── Fintech - Acme Payments/          ← Portfolio company
│   ├── Q3 FY26 Board Deck.pdf
│   ├── MIS Dec 2025.xlsx
│   └── ...
├── Climate - GreenCo/                ← Portfolio company
│   └── ...
└── .gitignore
```

## Data Privacy

This repo is designed to be **public** — it's a template others can clone and use. **All company data stays strictly local.** The protections are built in at multiple layers:

### How your data is protected

**Layer 1 — `.gitignore` (automatic):**
- All raw company files are blocked: PDFs, Excel (.xlsx/.xls), PowerPoint (.pptx/.ppt), CSV, Word docs
- Generated analysis files are blocked: `Running Summary.md`, `Monthly Report*`, `Team Update*`
- Deal Flow pitch files are explicitly blocked with additional patterns
- These files **cannot** be committed even if you run `git add .`

**Layer 2 — Claude's instructions (`CLAUDE.md`):**
- Claude is instructed to write all analysis **only** to local files in `Claude Summary/`
- Claude will **never** run commands that send data over the network (no `curl`, `wget`, API calls, etc.)
- Claude will **never** suggest uploading, emailing, or posting company data to any external service
- Claude will **never** include company financials in commit messages or git logs
- All processing uses local-only tools (file reads, Python/openpyxl for Excel, shell utilities)

**Layer 3 — Offline HTML outputs:**
- All HTML dashboards use **inline CSS only** — no external stylesheets, fonts, CDN links, analytics, or tracking
- Opening them in your browser makes **zero network requests** — fully offline
- You can verify this yourself: open any HTML file and check the browser's Network tab

### What requires your attention

- The HTML dashboards ship as **empty templates** in this repo. Once you process companies or pitches, they contain real data. **Do not commit the populated versions.** If `git status` shows them as modified, that's your company data — don't stage or push it.
- **Commit messages and PR descriptions** are public. Never reference specific company financials in them.

**Before pushing any changes:**
```bash
git diff --name-only    # Review what files changed
git diff                # Review the actual content — make sure no company data is included
```

**If you accidentally committed company data:**
```bash
git reset HEAD~1        # Undo the last commit (keeps your files intact)
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (Anthropic's CLI tool)
- Python 3 with `openpyxl` (for Excel files): `pip install openpyxl`

## Tips

- **Folder naming matters.** Always use `{Sector} - {Company Name}/`. No dates in folder names.
- **One at a time.** Claude processes companies and pitches sequentially to keep context clean.
- **Incremental updates.** When new files arrive for a company already processed, Claude adds a dated update section — it doesn't rewrite the whole summary.
- **Edit CLAUDE.md** to add your company details to the Portfolio Companies table. This helps Claude track what's in the portfolio.
- **Check the tracker.** The "Key Files Processed" and "Pitches Evaluated" sections in CLAUDE.md track what's been read.
- **Graduation.** When you invest in a pitch, move its folder from `Deal Flow/` to the repo root and process it as a portfolio company.

## Customization

The system is designed to be customizable:

- **Sectors:** Use whatever sector labels fit your portfolio (SaaS, Climate, Fintech, Health, etc.)
- **Template:** Edit the Standard Summary Template in CLAUDE.md to match what your team cares about
- **Scoring rubric:** Edit the Scoring Framework in CLAUDE.md to adjust dimension weights for deal flow
- **HTML styling:** The HTML templates use embedded CSS — modify the styles to match your brand
- **Extraction focus:** Edit "What to Extract" in CLAUDE.md to prioritize different metrics

## License

MIT
