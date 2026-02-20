# Portfolio Tracker

## What This Is
An AI-powered portfolio tracking system for investment teams. Drop company updates (PDFs, Excel files, PPTs) into folders. Claude reads them, extracts financials and key signals, and produces structured outputs — summaries, dashboards, red flag trackers, and team-shareable updates.

## How It Works
1. Create a folder per company: `{Sector} - {Company Name}/`
2. Drop update files (PDF, Excel, PPT) into the folder
3. Run Claude — it detects new files, processes them one at a time, and writes outputs
4. Share the HTML outputs with your team

## Folder Structure
```
portfolio-tracker/
├── CLAUDE.md                          ← You are here. Instructions for Claude.
├── detect_new_files.sh                ← Run to check for unprocessed files
├── Claude Summary/                    ← All Claude-generated outputs
│   ├── Portfolio Dashboard.html       ← One-page view of all companies (open in browser)
│   ├── Red Flags & Follow-ups.html   ← Action items, warnings, promises to track
│   ├── Team Update - {Mon} {Year}.html ← Shareable update for the team
│   ├── Running Summary.md             ← Detailed per-company analysis
│   └── Monthly Report - {Mon} {Year}.md ← End-of-month compilation
├── {Sector} - {Company A}/            ← One folder per portfolio company
│   ├── Q3 FY26 Update.pdf
│   ├── MIS Dec 2025.xlsx
│   └── ...
├── {Sector} - {Company B}/
│   └── ...
└── .gitignore
```

## Folder Naming Convention
Company folders MUST follow: `{Sector} - {Company Name}/`
- Use consistent sector labels across your portfolio (e.g., Climate, Fintech, Health, SaaS, Consumer, Media)
- Do NOT put dates or quarter info in folder names — the folder is the company anchor, files inside carry the dates
- Example: `Fintech - Acme Payments/` not `Fintech - Acme Payments Q3 2025/`

## Critical Rules

### One company at a time
Process ONE company per cycle. Read all files for that company, write the summary, update the dashboard and red flags, then STOP and ask which company to pick next. This keeps context clean and prevents mixing up data between companies.

### Don't over-read files
Read PDF/documents one page-range at a time (max 5-10 pages per call). For Excel files, read sheet names first, then prioritize P&L, KPIs, and summary sheets before diving into detail tabs.

### Update three files after each company
After processing each company, update ALL THREE outputs:
1. `Running Summary.md` — append the detailed analysis
2. `Portfolio Dashboard.html` — update that company's row
3. `Red Flags & Follow-ups.html` — add any new flags

### Always end with a question
After completing a company, ask the user which company to process next. Don't chain automatically.

## Portfolio Companies
<!-- Add your companies here as you create folders. Claude will auto-detect new ones. -->
<!-- Format: | Folder Name | Company | Sector | What They Do | Founder/CEO | -->

| Folder | Company | Sector | What They Do | Founder/CEO |
|--------|---------|--------|-------------|-------------|
| _Add rows as you create company folders_ | | | | |

## Key Files Processed (Tracker)
<!-- Claude updates this automatically as files are processed -->
<!-- Format: - [x] Folder / Filename (processed DATE) -->

_No files processed yet. Drop update files into company folders and run Claude._

## Workflows

### 1. Processing New Updates
1. **Detect new files:** Run `bash detect_new_files.sh` or ask Claude to scan for new files
2. **Process one company at a time.** Claude reads the files, extracts data, writes the summary following the Standard Template below
3. **After each company, Claude updates three outputs:** Running Summary, Dashboard (HTML), Red Flags (HTML)
4. **After all companies are done:** Claude generates/updates the Team Update HTML
5. **At end of month:** Claude compiles the Monthly Report from Dashboard + Red Flags + Running Summary

### 2. Incremental Updates (Same Company, New Quarter)
When a new file arrives for a company already in the Running Summary:
- Claude adds a **dated update section** under that company (not a full rewrite)
- Claude compares new numbers against the prior period already in the summary
- Dashboard and Red Flags are updated to reflect the latest data

### 3. Monthly Report
At end of each month, compile all updates into `Monthly Report - {Month} {Year}.md`:
- Portfolio-level summary (total revenue, key themes)
- Per-company: financials, operations, key signals (good and bad), action items
- Use the Dashboard for the overview and Red Flags for the action items

## Standard Summary Template
Every company summary in Running Summary MUST follow this structure. Skip sections only if data is truly unavailable.

```markdown
## {#}. {Company Name} — {Update Title} ({Period})

**Processed:** {date}
**Source files:** {list of files read}
**Company:** {one-line description of what they do}

### Financial Summary ({period})
Table with: Revenue, COGS, Gross Margin, EBITDA, PAT — absolute numbers + margins + trends.
Include QoQ and YoY comparisons where data exists.

### Revenue Trajectory
Monthly or quarterly trend table showing the shape of growth.

### Revenue Segments
Breakdown by channel, geography, product, or business line — whatever the company reports.

### Gross Margin by Segment
Identify which segments are margin-accretive vs margin-dilutive.

### Operating Cost Structure
Major cost lines as % of revenue. Identify the biggest cost levers.

### Cash Position & Runway
Cash balance, monthly burn rate, estimated runway in months.
Flag clearly if runway < 12 months.

### Key Operational Metrics
Customers, users, headcount, capacity utilization — whatever is relevant to this business.

### Key Signals & Red Flags
Numbered list. Be direct. Flag problems clearly — don't sugarcoat.
At least 3 specific concerns per company.

### Investor Questions
At least 5 specific questions. Reference actual data points from the update.
Not generic ("how's growth?") — specific ("Q3 gross margin dropped from 57% to 48%, what caused it?").
```

### Extraction Checklist
Before marking a company as processed, verify:
- [ ] Revenue: absolute number, growth rate (QoQ/YoY), trend direction
- [ ] Margins: Gross, EBITDA, PAT — absolute and trend
- [ ] Cash: balance, burn rate, runway estimate
- [ ] Segments: revenue and/or margin by channel/product/geography
- [ ] Comparison: vs prior period AND vs budget/plan if available
- [ ] Red flags: at least 3 specific concerns identified
- [ ] Questions: at least 5 specific investor questions written
- [ ] Dashboard HTML updated with this company's row
- [ ] Red Flags HTML updated with any new flags

## What to Extract From Each Update
- Company basics (what they do, founder, sector)
- Revenue, COGS, Gross Margin, EBITDA, PAT (absolute + margins + trends)
- Key operational metrics (customers, users, capacity, headcount)
- Growth rates (Q-o-Q, Y-o-Y)
- Segment breakdown if available
- Budget vs actuals if available
- Cash position, burn rate, runway
- Forward guidance / projections
- Red flags (margin compression, cash burn, customer concentration, runway concerns)
- Questions an investor should ask the founder

## Analyst Principles
- **Be direct.** Flag problems clearly — don't sugarcoat bad numbers.
- **Trends over absolutes.** Always compare current period to prior periods.
- **Skepticism on projections.** Note when forward guidance looks aggressive vs conservative.
- **Track promises.** Record what companies say they'll do. Verify next quarter.
- **Think like an investor.** What would you ask if your money was in this company?
- **Consistent format.** Every summary follows the same template so they're easy to scan across companies.

## HTML Output Guidelines
When generating or updating HTML files (Dashboard, Red Flags, Team Update):
- Use clean, professional styling — the files should look good opened in a browser
- Make them print-friendly (they may be printed for meetings)
- Use color coding: green for healthy signals, amber/yellow for watch items, red for urgent
- Team Update should be written so it can be shared as-is — no internal notes or draft language
- Include a "Last updated" date in the header of every HTML file

## Notes for Excel Files
The Claude Read tool cannot handle .xlsx files directly. When encountering Excel files:
- Use Python (openpyxl) via Bash to read them
- Read sheet names first to understand the structure
- Prioritize: P&L, Summary, KPIs sheets before detailed breakdowns
- For large sheets, read in chunks (first 80 rows, then continue if needed)
