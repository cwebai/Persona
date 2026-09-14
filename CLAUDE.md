# Persona site — working notes for Claude

This file exists so these rules travel with the project folder (e.g. to another PC), not just in Claude's session memory on this machine.

Профиль владельца проекта — в `profile.md`, прочитай его, чтобы понимать, для кого и зачем этот проект.

## Цель проекта

Учебный проект — курсовая/домашнее задание. Цель — показать навыки вёрстки и дизайна, а не служить действующим резюме или лидген-визиткой (хотя по факту он неплохо работает и в этой роли).

## Тон и правила

Текст на сайте — плоский и прямой: короткие декларативные фразы, факты без метафор и пафоса. Единственное исключение — блок «музыка»: там нормален личный, эмоциональный тон с цитатами.

В дизайне избегать:
- игрового/геймерского языка в UI-подписях (никаких «статус/класс/роль» — только понятные житейские подписи);
- лишнего декора и эффектов ради эффектов — если что-то не несёт смысла и не помогает читать, убирать;
- ярких/пёстрых цветов — держаться тёмной палитры везде, кроме музыкального блока.

## Ограничения

Не тащить фреймворки и сборку. Проект остаётся чистым HTML/CSS/JS в одном файле — никаких React/Vue, бандлеров или npm-зависимостей.

`index.html` is the active file being worked on — a dark "zine/bootleg-poster" reskin of the original draft. The old pre-reskin draft is archived at `_archive-draft/черновик.html` — **never edit it**, it's kept only for reference. Local dev server: `powershell -ExecutionPolicy Bypass -File serve.ps1`, serves `http://localhost:8080/`.

## Who the user is

SEO specialist, team lead of the SEO department. By education an engineer — degree specialty "проектирование экспозиционно-рекламных объектов" (design of exhibition/advertising objects: stands, pavilions, pillars, billboards, signage, roof installations). Graduated and started her first SEO job the same year, 2024. Became team lead exactly 2 years after her first position. 23 years old. Leads 3 people in her department (plus herself). Has run 7 projects from scratch since 2024, all still on support; average project tenure on the team is 1.5 years despite each specialist carrying 8-10 projects. Average ranking achieved: page 1-2 of search results, both Yandex and Google. 20+ published SEO articles, plus 2 academic papers from her university years. Because of her technical university background, her SEO approach leans on large, focused audits — technical SEO, UX, competitor comparison, and whole-niche analysis together, not surface-level review.

## Standing tone rule: no pathos

The user has repeatedly and explicitly rejected grandiose, poetic, or "pretentious" (её слово — "пафосно") copy for anything personal about her (headers, bio text, taglines). This applies most strongly to the "01 обо мне" section and the hero screen. Preferred register: plain, factual, short declarative sentences. Good examples she approved: "Инженер по образованию, тимлид по факту.", "23 года. По образованию инженер, сейчас руковожу SEO-отделом. Люблю разбираться, а не предполагать." When in doubt, write flatter and shorter, not more evocative.

Exception: the *music* block wants personal, emotional quotes/captions (lyrics, mood) — that's the one place first-person voice and feeling are wanted. Everywhere else about her (work, hero, about-me), stay plain.

## Block-by-block rules

### Hero / typography and video
- The hero name "КСЕНИЯ" is a supplied PNG image (`images/ya/ksenia_name.png`), never hand-built as SVG/CSS text — an earlier attempt looked bad.
- Background video (`#hv`) ping-pongs (plays forward then steps `currentTime` backward via `requestAnimationFrame`) instead of hard-looping — a jump cut at the loop point reads as ugly.
- The "личное дело" dossier fields at the top of the hero (`p-file` dl) use plain, literal labels (имя / профессия / образование / возраст), not game-character-sheet jargon (avoid things like "субъект/статус/роль/класс" — she found that too gamey and couldn't fill it in).

### Block 2 "работа" (dossier rows)
- Row order: **Достижения first**, open by default (`data-open="true"`), then Инженер → SEO-специалист → Тимлид SEO-отдела.
- Achievements use an animated count-up number (`.wrow__odds` / `<b data-count="N" data-suffix="...">0</b>`, driven by an IntersectionObserver already wired in the script) for whole numbers; non-integer or range values (e.g. "1,5 года", "1-2") are written as static text without `data-count`, since the counter animation can't handle decimals/ranges.
- `.wrow__odds` is `justify-content:center` so a wrapped second row of stats stays centered, not left-hung.
- Exhibits strip (`.work__exhibits`) shows her real engineering drawings (`images/work-*.png`): кронштейн, рама крышной установки, вал, зубчатое колесо, экспозиционный павильон.
- Avoid clichéd wrap-up phrases like "без хаоса" or generic "продолжает пополняться" — she's flagged both as sounding unnatural/filler.

### Block 3 "музыка"
- Dashes: **only the en dash "–" (U+2013), never em dash "—"** — anywhere in this project, text or code comments.
- Music genre always written in English (e.g. "Dark Trap") even though everything else is Russian.
- Quotes (`.music-clean-quote`) start with a capital letter.
- Artist avatar images: downscale to ~256×256 center-cropped before wiring in (they arrive oversized). Cover art can stay larger.
- Card sizing uses CSS custom properties `--mc-cover` / `--mc-desc` on `.music-clean-card` so cover/description/quote/button all scale together — if resizing again, check the poster-mode override block too (it previously had its own hardcoded column width that silently fought the light-mode one).
- The horizontal "scroll-scrubbed" carousel (`moveMusic`/`renderMusic` in the script) renders via an eased `currentShift` that chases a `targetShift` each animation frame — don't go back to setting `transform` directly from the scroll handler, that reintroduces jerky motion on the (now large) cards.

### Block 4 "игры" (game-deck cards)
- Each game card's short description (`.gd-text`) must read as a factual blurb **about the game** (plot/premise/mechanics) — never in the user's first-person voice ("I play because…"). Corrected independently for SH2 and Stardew.
- All 4 covers (`sh2-cover.jpg`, `hades-cover.jpg`, `dota-cover.jpg`, `stardew-cover.jpg`) are official textless key art with a separate official transparent logo overlaid on top (`.gd-cover-logo` img, `images/<game>-logo.png`) — this mirrors real box art. If a cover ever needs replacing again, prefer Steam's `library_hero_2x.jpg` (high-res, usually textless) and `logo.png` CDN assets for the given appid, and check the result actually contains the intended focal subject (for SH2 this matters: the cover must show Mary's ghostly face, not just James — use `images/sh/images (1).jpg` as that source, upscaled 2x).
- `.gd-detail-label` (the "информация об игре"/"кодекс"/"карта"/"любимые герои" headings) must render identically across all four cards — don't let a per-game variant override its font-size/family/margin.
- Card height is fixed *before* any click via `fitCardHeight()` (measures the expanded content once, applies it as `min-height` immediately) — the card must never visibly grow/shrink when clicked to expand.

## General
- On Windows, image resizing/cropping/quality work uses PowerShell + `System.Drawing` (`HighQualityBicubic` interpolation) — no ImageMagick/Node needed.
- After any layout/interaction change, verify with a headless-Chrome screenshot (CDP over the local `serve.ps1` server) before reporting done — this project has repeatedly had bugs that were only visible, not inferable from the code (stale cached transform values, CSS specificity fights between light/poster-mode rules, etc.).
