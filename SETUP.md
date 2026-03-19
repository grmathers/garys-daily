# Gary's Daily — Setup Guide

## One-time setup (5 minutes)

### Step 1: Create the GitHub repo
Go to https://github.com/new and create a new repo:
- **Name:** `garys-daily`
- **Visibility:** Public
- **Do NOT** add a README, .gitignore, or license (we already have files)

### Step 2: Push this folder to GitHub
Open a terminal in this `garys-daily-repo` folder and run:

```bash
git init
git add .
git commit -m "Initial commit — Gary's Daily v1.0"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/garys-daily.git
git push -u origin main
```

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.

### Step 3: Enable GitHub Pages
1. Go to your repo on GitHub → **Settings** → **Pages**
2. Under "Source", select **Deploy from a branch**
3. Branch: **main**, folder: **/ (root)**
4. Click **Save**

Your site will be live within ~60 seconds at:
**https://YOUR_GITHUB_USERNAME.github.io/garys-daily/**

### Optional: Custom domain
If you want a domain like `garysdaily.com`:
1. Buy the domain from Namecheap, Google Domains, or Cloudflare (~$10/year)
2. In GitHub Pages settings, enter your custom domain
3. Add a CNAME record pointing to `YOUR_GITHUB_USERNAME.github.io`

## How daily updates work
The Claude scheduled task runs at 7 AM every day. To have it auto-publish:
1. Ensure git credentials are configured on your machine
2. The scheduled task generates the new `index.html` and archives the previous day
3. It then commits and pushes to GitHub
4. GitHub Pages auto-deploys within seconds

## File structure
```
garys-daily-repo/
├── index.html          ← Current day's edition (always the latest)
├── archive/
│   ├── 2026-03-18.html ← First edition
│   ├── 2026-03-19.html ← (generated tomorrow)
│   └── ...             ← (one file per day, growing over time)
├── SETUP.md            ← This file
└── .nojekyll           ← Tells GitHub Pages to serve raw HTML
```
