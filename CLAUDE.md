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
│   ├── Promise Tracker.html          ← Accountability dashboard — tracks company commitments
│   ├── Collaboration Opportunities.html ← Cross-portfolio synergies (externally shareable)
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

### Protect company data — everything stays local
All company data processed by this tool is **confidential**. Every piece of data — raw files, extracted numbers, generated analysis — must stay on the local machine. Follow these rules without exception:

**All outputs stay local:**
- Write all analysis ONLY to the designated local files (`Claude Summary/` outputs). Never write company data to any other location.
- **Never suggest committing or pushing generated outputs** (Running Summary, Monthly Reports, Team Updates, or populated HTML dashboards) to git. The `.gitignore` blocks most of these, but the HTML template files (Dashboard, Red Flags, Promise Tracker, Collaboration Opportunities) are tracked as empty templates. Once they contain company data, do NOT stage or commit them.
- **Never include real company data in commit messages, PR descriptions, or git logs.** These are public if the repo is pushed.

**No external transmission:**
- **Never suggest uploading, emailing, or posting** company financials, investor updates, or generated analysis to any external service, API, or URL.
- **Never run commands that send data over the network** — no `curl`, `wget`, `httpie`, `nc`, API calls, webhooks, or any tool that transmits data externally. All processing must use local-only tools (file reads, Python scripts for Excel parsing, etc.).
- **Never pipe or redirect company data** to any command that could transmit it (e.g., no `cat file | curl`, no writing to `/dev/tcp`, no logging to remote services).
- **Never suggest installing packages or tools** to process company data — only use what's already available locally (`openpyxl` for Excel, standard Python, built-in shell tools). If a tool isn't available, ask the user to install it themselves.

**During processing:**
- When summarizing financials in your responses (chat output), keep it to what's needed for the user to review your work. Don't dump raw data tables into chat unnecessarily — write them to the output files instead.
- **Never echo or print full file contents** of company documents to the terminal. Read, extract, and write to output files.
- If you need to show the user a data point for confirmation, show the minimum necessary — not the full document.

**Collaboration Opportunities (externally shareable):**
- This file is designed to be shared with founders and co-investors. Even so, do NOT include specific revenue figures, margin percentages, cash positions, burn rates, or any numbers that came from confidential updates. Describe synergies in qualitative terms only.

**Git protections:**
- **If the user asks to push to a remote:** warn them that the HTML dashboard files may contain company data and suggest they verify `git diff` before pushing. Do not push without this warning.
- The `.gitignore` is pre-configured to block raw data files (PDF, Excel, PPT, CSV, DOC) and generated markdown outputs. Do not modify `.gitignore` to weaken these protections.

### One company at a time
Process ONE company per cycle. Read all files for that company, write the summary, update the dashboard and red flags, then STOP and ask which company to pick next. This keeps context clean and prevents mixing up data between companies.

### Don't over-read files
Read PDF/documents one page-range at a time (max 5-10 pages per call). For Excel files, read sheet names first, then prioritize P&L, KPIs, and summary sheets before diving into detail tabs.

### Update five files after each company
After processing each company, update ALL FIVE outputs:
1. `Running Summary.md` — append the detailed analysis
2. `Portfolio Dashboard.html` — update that company's row
3. `Red Flags & Follow-ups.html` — add any new flags
4. `Promise Tracker.html` — add any new promises, verify previous promises if data available
5. `Collaboration Opportunities.html` — add any cross-portfolio synergies identified

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
3. **After each company, Claude updates five outputs:** Running Summary, Dashboard (HTML), Red Flags (HTML), Promise Tracker (HTML), Collaboration Opportunities (HTML)
4. **After all companies are done:** Claude generates/updates the Team Update HTML
5. **At end of month:** Claude compiles the Monthly Report from Dashboard + Red Flags + Promise Tracker + Running Summary

### 2. Incremental Updates (Same Company, New Quarter)
When a new file arrives for a company already in the Running Summary:
- Claude adds a **dated update section** under that company (not a full rewrite)
- Claude compares new numbers against the prior period already in the summary
- Dashboard and Red Flags are updated to reflect the latest data
- **Promise verification:** Check the Promise Tracker for any prior promises from this company. Update their status (Delivered, Partially Delivered, Missed) based on the new data. Add any new promises found.
- **Collaboration review:** Re-assess collaboration opportunities now that new data is available. Update existing opportunities or add new ones.

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

### Promises & Forward Guidance
Table with: Promise | Category | Target Date | Status
Record every forward-looking commitment: revenue targets, product launches, hiring plans, fundraising timelines, operational milestones.
If this is an incremental update, verify prior promises against actual results.

### Collaboration Notes
Identify potential synergies with other portfolio companies.
Note: customer-supplier fits, technology integrations, shared markets, co-development opportunities.
Keep the tone constructive — these notes feed into the externally-shareable Collaboration Opportunities dashboard.

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
- [ ] Promises extracted and added to Promise Tracker HTML
- [ ] Previous promises from this company verified (if incremental update)
- [ ] Collaboration opportunities identified and added to Collaboration Opportunities HTML
- [ ] Both new HTML files (Promise Tracker, Collaboration Opportunities) updated

## What to Extract From Each Update
- Company basics (what they do, founder, sector)
- Revenue, COGS, Gross Margin, EBITDA, PAT (absolute + margins + trends)
- Key operational metrics (customers, users, capacity, headcount)
- Growth rates (Q-o-Q, Y-o-Y)
- Segment breakdown if available
- Budget vs actuals if available
- Cash position, burn rate, runway
- Forward guidance / projections
- **Promises and commitments** — revenue targets, product launch dates, hiring plans, fundraising timelines, operational milestones. Anything the company says it will do by a specific date or quarter.
- Red flags (margin compression, cash burn, customer concentration, runway concerns)
- **Potential synergies** — customer-supplier fits with other portfolio companies, shared technology, overlapping markets, co-development or cross-selling opportunities
- Questions an investor should ask the founder

## Promise Extraction Rules

### What Counts as a Promise
A promise is any forward-looking commitment with a specific or implied timeframe:
- **Financial targets:** "We expect to hit ₹10Cr revenue by Q4", "Targeting 60% gross margin by March"
- **Product milestones:** "Launching v2 in Q1", "Mobile app expected by June"
- **Operational goals:** "Hiring 50 engineers by year-end", "Opening 3 new warehouses in H2"
- **Fundraising:** "Planning Series B in Q2 2026", "Targeting $20M raise"
- **Partnerships/deals:** "Expecting to close enterprise deal with X by Q3"

Do NOT record vague aspirations without timeframes (e.g., "we want to grow faster"). Only track commitments with measurable outcomes.

### How to Record Promises
Each promise entry must include:
- **Company** — which company made the promise
- **Promise** — exact commitment, quoted where possible
- **Category** — Financial, Product, Operational, or Fundraising
- **Source** — which file/update the promise came from, with date
- **Target date** — when they said they'd deliver (quarter or specific date)
- **Status** — current status (see below)

### Promise Status Definitions
- **Pending** — recorded, not yet due, no update available
- **On Track** — subsequent update shows progress toward delivery
- **Delivered** — commitment met, verified with data
- **Partially Delivered** — some progress but fell short of the full commitment
- **Missed** — target date passed without delivery or explicit acknowledgment
- **Expired** — no longer relevant (company pivoted, target changed, etc.)

### Verification Process
When processing an incremental update for a company:
1. Check the Promise Tracker for all open promises from that company
2. Look for evidence in the new data that confirms or contradicts each promise
3. Update the status with a brief note explaining the evidence
4. If a promise was missed, flag it in Red Flags as well
5. Record any new promises found in the current update

## Collaboration Identification Rules

### Opportunity Types
- **Customer-Supplier** — one portfolio company could be a customer of another
- **Technology Integration** — companies whose tech stacks or platforms could integrate
- **Shared Market** — companies targeting the same customer segment from different angles
- **Co-development** — companies that could jointly build a product or feature
- **Cross-selling** — companies whose sales teams could refer business to each other
- **Talent/Expertise** — companies that could share knowledge, advisors, or talent pools

### How to Record Opportunities
Each opportunity entry must include:
- **Company A** and **Company B** — the two companies involved
- **Type** — one of the types above
- **Description** — specific, actionable description of the synergy
- **Impact** — High, Medium, or Low (based on potential revenue/strategic value)
- **Status** — Identified, Exploring, Active, or Realized
- **Date identified** — when the opportunity was first noted

### Impact Assessment
- **High** — could materially affect revenue, costs, or strategic positioning for either company
- **Medium** — useful but not transformative; operational efficiency or modest revenue potential
- **Low** — nice-to-have; informational or networking value

### Tone Requirements
The Collaboration Opportunities dashboard is **externally shareable** — founders and co-investors may see it. Therefore:
- Use constructive, opportunity-focused language
- Do NOT include confidential financials or internal red flags
- Frame synergies as value-creation opportunities, not obligations
- Be specific enough to be actionable but not so detailed that it exposes sensitive data

## Analyst Principles
- **Be direct.** Flag problems clearly — don't sugarcoat bad numbers.
- **Trends over absolutes.** Always compare current period to prior periods.
- **Skepticism on projections.** Note when forward guidance looks aggressive vs conservative.
- **Track promises.** Record what companies say they'll do. Verify next quarter. Use the Promise Tracker to hold companies accountable.
- **Verify promises.** When processing incremental updates, always check prior promises against actual results. Flag misses clearly — a pattern of missed promises is a red flag in itself.
- **Think like an investor.** What would you ask if your money was in this company?
- **Find connections.** Actively look for synergies across portfolio companies. A well-connected portfolio creates more value than the sum of its parts.
- **Consistent format.** Every summary follows the same template so they're easy to scan across companies.

## HTML Output Guidelines
When generating or updating HTML files (Dashboard, Red Flags, Team Update):
- Use clean, professional styling — the files should look good opened in a browser
- Make them print-friendly (they may be printed for meetings)
- Use color coding: green for healthy signals, amber/yellow for watch items, red for urgent
- Team Update should be written so it can be shared as-is — no internal notes or draft language
- Include a "Last updated" date in the header of every HTML file
- **Promise Tracker:** Use status badges (Pending=amber, On Track=light-green, Delivered=green, Partially Delivered=orange, Missed=red, Expired=gray) and category badges (Financial, Product, Operational, Fundraising). Group by urgency: overdue first, then due this quarter, then active, then resolved.
- **Collaboration Opportunities:** Keep tone constructive and externally shareable — no confidential financials. Use impact badges (High=blue, Medium=amber, Low=gray). Include a synergy matrix showing opportunity counts between company pairs.

## Notes for Excel Files
The Claude Read tool cannot handle .xlsx files directly. When encountering Excel files:
- Use Python (openpyxl) via Bash to read them
- Read sheet names first to understand the structure
- Prioritize: P&L, Summary, KPIs sheets before detailed breakdowns
- For large sheets, read in chunks (first 80 rows, then continue if needed)
