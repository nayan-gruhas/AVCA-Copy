# Portfolio Tracker

An AI-powered portfolio tracking system for investment teams. Drop company updates (PDFs, Excel files, PPTs) into folders. Claude reads them, extracts financials and key signals, and produces structured outputs — summaries, dashboards, red flag trackers, and team-shareable updates.

## Quick Start

1. **Clone this repo**
   ```bash
   git clone <repo-url>
   cd portfolio-tracker
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

## What You Get

| Output | Format | Purpose |
|--------|--------|---------|
| **Running Summary** | Markdown | Detailed per-company analysis with financials, metrics, signals |
| **Portfolio Dashboard** | HTML | One-page view of all companies — health, revenue, burn, signals |
| **Red Flags & Follow-ups** | HTML | Urgent items, financial warnings, positive signals, promises to track |
| **Promise Tracker** | HTML | Accountability dashboard — tracks company commitments and delivery rates |
| **Collaboration Opportunities** | HTML | Cross-portfolio synergies and value creation opportunities (externally shareable) |
| **Team Update** | HTML | Shareable summary — one card per company, designed for team distribution |
| **Monthly Report** | Markdown | End-of-month compilation for the investment team |

## How It Works

Claude reads the `CLAUDE.md` file in this repo for all its instructions. When you start a Claude Code session in this directory, it knows:
- How to find and process new files
- What data to extract (revenue, margins, cash, segments, red flags)
- How to structure summaries consistently
- How to update the HTML outputs
- How to handle Excel files (via Python/openpyxl)

### Processing Flow

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

### Detecting New Files

Run the detection script to see which files haven't been processed yet:

```bash
bash detect_new_files.sh
```

## Folder Structure

```
portfolio-tracker/
├── README.md                         ← You are here
├── CLAUDE.md                         ← Instructions for Claude (don't delete this)
├── detect_new_files.sh               ← Script to find unprocessed files
├── Claude Summary/                   ← All Claude-generated outputs
│   ├── Portfolio Dashboard.html
│   ├── Red Flags & Follow-ups.html
│   ├── Promise Tracker.html
│   ├── Collaboration Opportunities.html
│   ├── Team Update - Feb 2026.html
│   ├── Running Summary.md
│   └── Monthly Report - Feb 2026.md
├── Fintech - Acme Payments/          ← One folder per company
│   ├── Q3 FY26 Board Deck.pdf
│   ├── MIS Dec 2025.xlsx
│   └── ...
├── Climate - GreenCo/
│   └── ...
└── .gitignore
```

## Data Privacy

This repo is designed to be **public** — it's a template others can clone and use. All company data stays local. The protections are built in:

**What's protected by `.gitignore` (automatically excluded from git):**
- All raw company files: PDFs, Excel (.xlsx/.xls), PowerPoint (.pptx/.ppt), CSV, Word docs
- Generated analysis: `Running Summary.md`, `Monthly Report*`, `Team Update*`

**What requires your attention:**
- The HTML dashboards (Portfolio Dashboard, Red Flags, Promise Tracker, Collaboration Opportunities) ship as **empty templates** in this repo. Once you process companies, they contain real financial data. **Do not commit the populated versions.** If `git status` shows them as modified, that's your company data — don't stage or push it.
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

Claude is instructed (via `CLAUDE.md`) to never suggest committing or sharing company data externally.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (Anthropic's CLI tool)
- Python 3 with `openpyxl` (for Excel files): `pip install openpyxl`

## Tips

- **Folder naming matters.** Always use `{Sector} - {Company Name}/`. No dates in folder names.
- **One company at a time.** Claude processes companies sequentially to keep context clean.
- **Incremental updates.** When new files arrive for a company already processed, Claude adds a dated update section — it doesn't rewrite the whole summary.
- **Edit CLAUDE.md** to add your company details to the Portfolio Companies table. This helps Claude track what's in the portfolio.
- **Check the tracker.** The "Key Files Processed" section in CLAUDE.md tracks what's been read. If a file isn't listed there, Claude will pick it up on the next run.

## Customization

The system is designed to be customizable:

- **Sectors:** Use whatever sector labels fit your portfolio (SaaS, Climate, Fintech, Health, etc.)
- **Template:** Edit the Standard Summary Template in CLAUDE.md to match what your team cares about
- **HTML styling:** The HTML templates use embedded CSS — modify the styles to match your brand
- **Extraction focus:** Edit "What to Extract" in CLAUDE.md to prioritize different metrics

## License

MIT
