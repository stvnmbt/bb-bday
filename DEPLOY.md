# Deploying bb's Birthday Site to GitHub Pages

The site is pure static files (no build step). Everything she sees ships in:
`index.html` + `assets/` (photos, audio, posters) + `.nojekyll`.

## One-time setup

1. **Install Git** if you don't have it: https://git-scm.com/downloads
2. **Create a GitHub account** if needed: https://github.com
3. **Create a new repo** at https://github.com/new
   - Name it something generic for low-key vibes, e.g. `bb`
   - Public. (Free GitHub Pages requires a public repo — that's fine, see Privacy below.)
   - No README, no .gitignore (we already made one).

## Publish

Open PowerShell in the `bb website` folder (or `cd "C:\Users\ambat\OneDrive\Documents\code\bb website"`) and run:

```powershell
git init
git add .
git commit -m "happy birthday bb"
git branch -M main
git remote add origin https://github.com/<YOUR-USERNAME>/bb.git
git push -u origin main
```

(It'll ask you to log in — use a Personal Access Token or the browser login GitHub offers.)

Then:

1. Open the repo on GitHub → **Settings** → **Pages** (left sidebar).
2. Under "Build and deployment": Source = **Deploy from a branch**, Branch = **main**, folder = **/ (root)** → Save.
3. Wait ~1–2 minutes. The site is live at:

   **`https://<YOUR-USERNAME>.github.io/bb/`**

4. Test it on your phone too. Share only this link with bb. 😌

## Privacy (low-key mode)

- Free GitHub Pages must be a public repo, but the site already has `<meta name="robots" content="noindex">` so search engines won't index it.
- The repo name is generic; nothing links to it publicly. Only people with the URL find it.

## Updating later (editing text, swapping photos, new movies)

1. Edit `index.html` (text/notes) or drop new files into `assets/`.
2. Push:

```powershell
git add .
git commit -m "update"
git push
```

Live in ~1 minute.

## Optional: custom domain

Settings → Pages → Custom domain → e.g. `bb.example.com`, then add a CNAME record at your registrar pointing to `<YOUR-USERNAME>.github.io`. GitHub adds a `CNAME` file to the repo automatically.
