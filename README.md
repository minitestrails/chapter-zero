# Chapter Zero

**Chapter Zero** is the Bridgetown starter for technical guides. Scaffolding before your first real chapter.

It is the foundational setup you need before diving into actual content: a landing page, ordered chapters with a sidebar, blog, contact form, newsletter slot, support banner, and auto-generated social preview images. Like "chapter 0" in a book, it is the starting point. You bring the lessons.

[minitestrails.com](https://minitestrails.com) runs a full curriculum on this shell.

## Quickstart

```sh
git clone https://github.com/minitestrails/chapter-zero.git
cd chapter-zero
bin/setup
bin/dev
```

`bin/setup` installs Ruby gems and npm packages, creates `.env` from `.env.sample` when missing, and runs an initial site build. `.env` sets `BRIDGETOWN_ENV=development` so analytics stay off and your dev Stripe support link is used when configured.

### Prerequisites

- **Ruby** — version in `.ruby-version` (rbenv, asdf, or chruby recommended)
- **Node.js** + **npm** — for Tailwind, esbuild, and Stimulus
- **Optional:** ImageMagick (`magick` or `convert`) and `rsvg-convert` (librsvg) for build-time OG PNG generation (see [OG images](#og-images))

Open [http://localhost:4000](http://localhost:4000) (override with `PORT` if needed).

**Read the [introduction chapter](/guide/introduction-chapter-zero/) first** while running `bin/dev` before customizing anything. It explains what ships in the box, how search and OG images work, and the customize checklist—skipping it means re-discovering the same wiring by trial and error. Chapter 0 has `development_only: true` and is omitted from production builds.

After setup, customize site metadata and landing partials, then add your first lesson at `src/_guide/01-your-topic.md` (chapter 1). `/guide/lesson-one` ships as a **coming soon** placeholder so you can see how unpublished chapters look in the sidebar.

## What ships in the box

- **Dark DaisyUI theme** with Tailwind CSS v4 (see [Theming with DaisyUI](#theming-with-daisyui) below)
- **Landing page**: hero, featured testimonial, how-it-works steps, audience cards, featured chapters, testimonials grid, newsletter slot, author card (`src/_partials/landing/`; edit markup directly or delete sections you do not need)
- **Guide collection**: Markdown chapters under `src/_guide/` with `order`, `slug`, and `layout: guide_chapter`
- **Blog collection**: dated posts under `src/_blog/`
- **Components**: DaisyUI-based UI in `src/_components/` (`shared`, `guide`, `blog`); layouts and landing partials stay thin
- **Newsletter (ConvertKit)**: `Shared::NewsletterForm` on the landing page, in coming-soon chapters, and anywhere else you render it. Set `convertkit_form_id` and `convertkit_account` in `site_metadata.yml`; the form stays hidden until both are set. Section copy lives in `src/_partials/landing/_newsletter.erb`.
- **Google Analytics**: optional GA4 via `google_analytics_id` in `site_metadata.yml`. The tracking snippet in `src/_partials/_head.erb` loads in production only (not during local `bin/dev`).
- **Privacy page**: starter copy at `src/privacy.md`, published at `/privacy` and linked from the footer. Edit it to describe your analytics, newsletter, support links, and contact form.
- **OG images**: per-chapter and per-post 1200×630 PNGs at build time
- **Netlify-friendly contact form** markup on `/contact`
- **Site search**: real-time Lunr search in the header via [bridgetown-quick-search](https://github.com/bridgetownrb/bridgetown-quick-search); indexes guide chapters, blog posts, and pages
- **Heading anchors**: `#` permalinks on `h2`–`h4` in guide and blog content (`plugins/builders/heading_anchors.rb`)
- **Code copy**: copy-to-clipboard buttons on fenced code blocks (Stimulus `clipboard` controller on guide and blog prose)
- **Stimulus**: [Hotwired Stimulus](https://stimulus.hotwired.dev/) for client-side behavior that is not included in stock Bridgetown (see [JavaScript with Stimulus](#javascript-with-stimulus) below)

## Bridgetown

Chapter Zero is a static site built with [Bridgetown](https://www.bridgetownrb.com/). Collections (`guide`, `blog`), layouts, partials, plugins, and `bin/bridgetown deploy` all follow Bridgetown conventions.

For configuration, content model, and deployment details, use the official documentation: [bridgetownrb.com/docs](https://www.bridgetownrb.com/docs).

## JavaScript with Stimulus

Bridgetown bundles frontend assets with esbuild and a `frontend/javascript/index.js` entrypoint, but **does not ship Stimulus by default**. Chapter Zero adds [Hotwired Stimulus](https://stimulus.hotwired.dev/) for small, declarative client-side behavior.

### What's set up

- **Package**: `@hotwired/stimulus` in `package.json`
- **Bootstrap**: `frontend/javascript/index.js` starts a Stimulus application and exposes it as `window.Stimulus`
- **Controllers**: files in `frontend/javascript/controllers/` named `*_controller.js` (or `*-controller.js`) are auto-registered at build time

The identifier comes from the filename: `clipboard_controller.js` → `data-controller="clipboard"`. Nested folders use double dashes (`folder/foo_controller.js` → `data-controller="folder--foo"`).

### Adding a controller

1. Create `frontend/javascript/controllers/my_feature_controller.js`
2. Extend Stimulus's `Controller` class
3. Attach it in a template with `data-controller="my-feature"`

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // runs when the element appears in the DOM
  }
}
```

Use `data-action` attributes to wire events (for example `data-action="click->my-feature#handleClick"`). Restart or let `bin/dev` rebuild the frontend bundle after you add or change controllers.

### Controllers in use

| Controller | Where | Purpose |
| --- | --- | --- |
| `clipboard` | `guide_chapter.erb`, `blog_post.erb` prose wrapper | Copy buttons on fenced code blocks |

See [Code copy](#code-copy) for details on the clipboard controller.

## Theming with DaisyUI

The UI is styled with [DaisyUI](https://daisyui.com/) component classes on top of Tailwind CSS v4. Buttons, cards, alerts, the support banner, and most layout chrome use DaisyUI patterns.

The active theme is set in `frontend/styles/index.css`:

```css
@plugin "daisyui" {
  themes: dark --default;
}
```

To add themes, change the default, or customize colors and radius, follow the [DaisyUI themes documentation](https://daisyui.com/docs/themes/). After you change CSS, restart `bin/dev` so Tailwind picks up the update.

## Customize checklist

Work through these before you write lesson one:

1. **`src/_data/site_metadata.yml`**: title, tagline, email, logo and favicon paths, `testimonials_max`, `hide_suggest_topic`, optional `convertkit_form_id` + `convertkit_account`, Stripe `support_url` / `support_url_development`, `google_analytics_id`, `contact_form_action`
2. **`src/_partials/landing/`**: landing page sections (hero, steps, audience, newsletter, author card, and so on). Edit the markup in place or remove `<%= render "landing/…" %>` lines from `src/index.md` for sections you do not want.
3. **`src/_data/testimonials.yml`**: reader quotes (`feedback`, `highlighted_text`, optional `image_path` for site images or `image_url` for external URLs). Set `featured: true` on one entry for the spotlight; the masonry grid shows up to `testimonials_max` more (default 5 in `site_metadata.yml`).
4. **`src/images/`**: logo, favicon, `blog-og-background.png`, `og-image.png` (keep default OG paths in sync with `image` front matter on `index.md` and `guide.md`)
5. **`config/initializers.rb`**: set production `url` to your domain (`https://yourdomain.com`)
6. **`src/_guide/01-…`**: your first real content chapter at order 1 (replace or delete the sample lesson-one placeholder when you are ready). Keep `00-introduction-chapter-zero.md` for local docs—it does not publish to production.

Set `show_chapter_zero_credit: false` in `site_metadata.yml` if you do not want the footer link to [minitestrails.com/chapter-zero](https://minitestrails.com/chapter-zero).

Run `bin/dev` and preview at [http://localhost:4000](http://localhost:4000) after each batch of changes.

## Architecture

UI is **component-first**: Ruby classes in `src/_components/` with DaisyUI classes in matching `.erb` templates. Shared chrome (header, footer, support banner) and landing sections (`src/_partials/landing/`) keep pages and layouts small.

Guide chapters are Markdown in `src/_guide/` with front matter like:

```yaml
title: Your chapter title
description: One line for cards and OG images
order: 1
layout: guide_chapter
slug: your-url-segment
featured: true  # optional; show on the landing page featured chapters section (sorted by order)
hide_content_feedback: true  # optional; omit or set false to show the feedback link
```

The `slug` becomes `/guide/your-url-segment/`. `order` controls sidebar sort and featured chapter order on the landing page.

Use `is_coming_soon: true` for chapters you have not published yet: readers see the coming-soon card and newsletter prompt instead of body content (see `/guide/lesson-one`).

Set `hide_content_feedback: true` on a guide chapter or blog post to hide the feedback link at the bottom of the page.

Set `development_only: true` to include a resource only in development builds (chapter 0 uses this). Production builds omit it from the site, sidebar, search, and OG output.

## Site search

Search is powered by [bridgetown-quick-search](https://github.com/bridgetownrb/bridgetown-quick-search). The bar lives in `src/_partials/_header.erb` and indexes guide chapters, blog posts, and pages at build time into `/bridgetown_quick_search/index.json`.

### Excluding or customizing indexed content

Front matter on any page or collection document:

- `exclude_from_search: true` — omit from the index (used on the landing page, contact, and privacy)
- `quick_search_content: "…"` — override the text indexed for that page (defaults to rendered page content)

### Component options

The search component accepts Liquid variables (see `_header.erb` for the live config):

| Variable | Description |
| --- | --- |
| `placeholder` | Input placeholder text |
| `input_class` | CSS classes on the search input |
| `theme` | `"dark"` or `"light"` (popup theme) |
| `snippet_length` | Character length of each result snippet (default 142) |
| `display_collection` | Show which collection each result belongs to |

### Styling search results

The results popup is a shadow-DOM web component. Tweak it in `frontend/styles/bridgetown-quick-search.css` with CSS variables on `bridgetown-search-results` (`--link-color`, `--divider-color`, `--text-color`, `--border-radius`) or `::part()` selectors. See the [plugin README](https://github.com/bridgetownrb/bridgetown-quick-search#styling) for details.

## Reader experience extras

These are small UX additions on top of stock Bridgetown—they ship with Chapter Zero and need no extra setup.

### Heading anchors

`plugins/builders/heading_anchors.rb` adds a `#` link after every `h2`, `h3`, and `h4` inside `<article>` that has an `id`. Readers can click or copy a permalink to that section.

Give headings stable IDs in Markdown with Kramdown's attribute list syntax:

```markdown
## Local development {#local-development}
```

Styles live in `frontend/styles/guide-chapter.css` (`scroll-margin-top` keeps anchored headings clear of the header).

### Code copy

Guide chapters and blog posts wrap prose in `data-controller="clipboard"` (`guide_chapter.erb` and `blog_post.erb`). The Stimulus controller in `frontend/javascript/controllers/clipboard_controller.js` adds a copy button to each `pre.highlight` block. Styles are in `frontend/styles/clipboard.css`. No extra markup in your Markdown—fenced code blocks with a language tag get copy buttons automatically. See [JavaScript with Stimulus](#javascript-with-stimulus) for how controllers are registered.

## Writing chapter content

Guide chapters and blog posts are Markdown (Kramdown + GFM). For a rendered reference of headings, lists, code, tables, footnotes, and more, see the sample post `/blog/hello-world` ([Hello from the blog](https://minitestrails.com/blog/hello-world/)).

### Tip callouts

Render callouts with `Shared::Tip` in guide Markdown via ERB. In `.erb` files use a single `%`; in guide Markdown escape as `%%` so Bridgetown does not evaluate at build time. Blog posts are plain Markdown—no ERB components.

### Code blocks

Fenced blocks with a language tag get syntax highlighting and a **copy** button (see [Code copy](#code-copy)). Examples are in the [Markdown reference post](https://minitestrails.com/blog/hello-world/#inline-and-fenced-code).

### Blog posts

Posts live in `src/_blog/` with `layout: blog_post`, a `date`, and a `slug`. They appear on the landing page and at `/blog`.

## OG images

Chapter and blog posts get auto-generated 1200×630 PNGs at build time (saved under `output/og/`).

### Preview in the browser

During `bin/dev`, open any OG image directly in the browser by inserting `/og/` into the page URL and appending `.png`:

```
http://localhost:4000/og/guide/introduction-chapter-zero.png
```

The pattern is `/og/{collection}/{slug}.png` for `guide` and `blog` collections. Examples:

- Guide chapter: `/og/guide/introduction-chapter-zero.png` (matches `/guide/introduction-chapter-zero/` in development)
- Blog post: `/og/blog/hello-world.png` (matches `/blog/hello-world/`)

In production, swap the host: `https://yourdomain.com/og/guide/your-chapter-slug.png`.

### Dynamic OG routes

The `/og/…` URLs are served by a Roda route in `server/routes/og_image.rb`. During `bin/dev`, if a pre-built PNG is missing, the route generates one on the fly from `output/og/{collection}/manifest.json`.

Only collections listed in `OG_COLLECTIONS` are handled:

```ruby
OG_COLLECTIONS = %w[guide blog].freeze
```

If you add a new collection and want the same `/og/{collection}/{slug}.png` previews, add its label to `OG_COLLECTIONS` in `server/routes/og_image.rb`. For build-time PNG generation, update the matching `OG_COLLECTIONS` constant in `plugins/builders/site_og_images.rb` as well.

### Build dependencies

The build needs:

- **ImageMagick** (`magick` or `convert` on PATH)
- **rsvg-convert** (librsvg)

## Deployment

```sh
bin/bridgetown deploy
```

Publish the `output/` folder. Netlify config is included in `netlify.toml`.

## License

MIT. See [LICENSE](LICENSE).
