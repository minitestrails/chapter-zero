---
title: Introduction to Chapter Zero
description: What Chapter Zero includes, how to customize it, and how to publish your first lesson.
order: 0
featured: true
layout: guide_chapter
slug: introduction-chapter-zero
development_only: true
---

Welcome to Chapter Zero. This is the meta chapter: it explains the scaffold, not your topic yet.

Chapter Zero is the foundational setup before your real content: a landing page, ordered chapters with a sidebar, blog, contact form, newsletter slot, support banner, and auto-generated social preview images. Like "chapter 0" in a book, it is the starting point. You bring the lessons.

After you finish this chapter, customize site metadata and landing partials below, then add your first real lesson at `src/_guide/01-your-topic.md` (chapter 1). [Lesson one](/guide/lesson-one) ships as a **coming soon** placeholder so you can see how unpublished chapters look in the sidebar.

This chapter has `development_only: true` in front matter—it is included when you run `bin/dev` or build with `BRIDGETOWN_ENV=development`, and omitted from production builds so only your curriculum ships.

## Local development {#local-development}

From the project root after cloning:

```sh
bin/setup
bin/dev
```

`bin/setup` installs Ruby gems (`bundle install`), npm packages, creates `.env` from `.env.sample` if missing, and runs an initial `bin/bridgetown build`. `.env` sets `BRIDGETOWN_ENV=development` so analytics stay off and your dev Stripe support link is used when configured.

### Prerequisites {#prerequisites}

- **Ruby** — match `.ruby-version` (rbenv, asdf, or chruby recommended)
- **Node.js** + **npm** — frontend bundling (Tailwind, esbuild, Stimulus)
- **Optional:** ImageMagick (`magick` or `convert`) and `rsvg-convert` (librsvg) for build-time OG PNGs (see [OG images](#og-images)); dynamic `/og/…` previews in `bin/dev` work without them

Open [http://localhost:4000](http://localhost:4000) (override with `PORT` if needed). Use `bin/dev` rather than `bin/bridgetown start` so you pick up the same defaults as the rest of this project.

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

## JavaScript with Stimulus {#javascript-with-stimulus}

Bridgetown bundles frontend assets with esbuild and a `frontend/javascript/index.js` entrypoint, but **does not ship Stimulus by default**. Chapter Zero adds [Hotwired Stimulus](https://stimulus.hotwired.dev/) for small, declarative client-side behavior.

### What's set up {#stimulus-setup}

- **Package**: `@hotwired/stimulus` in `package.json`
- **Bootstrap**: `frontend/javascript/index.js` starts a Stimulus application and exposes it as `window.Stimulus`
- **Controllers**: files in `frontend/javascript/controllers/` named `*_controller.js` (or `*-controller.js`) are auto-registered at build time

The identifier comes from the filename: `clipboard_controller.js` → `data-controller="clipboard"`. Nested folders use double dashes (`folder/foo_controller.js` → `data-controller="folder--foo"`).

### Adding a controller {#stimulus-adding}

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

### Controllers in use {#stimulus-controllers}

| Controller | Where | Purpose |
| --- | --- | --- |
| `clipboard` | `guide_chapter.erb`, `blog_post.erb` prose wrapper | Copy buttons on fenced code blocks |

See [Code copy](#code-copy) for details on the clipboard controller.

## Theming with DaisyUI {#theming-with-daisyui}

The UI is styled with [DaisyUI](https://daisyui.com/) component classes on top of Tailwind CSS v4. Buttons, cards, alerts, the support banner, and most layout chrome use DaisyUI patterns.

The active theme is set in `frontend/styles/index.css`:

```css
@plugin "daisyui" {
  themes: dark --default;
}
```

To add themes, change the default, or customize colors and radius, follow the [DaisyUI themes documentation](https://daisyui.com/docs/themes/). After you change CSS, restart `bin/dev` so Tailwind picks up the update.

## Customize checklist {#customize}

Work through these before you write lesson one:

1. **`src/_data/site_metadata.yml`**: title, tagline, email, logo and favicon paths, `testimonials_max`, `hide_suggest_topic`, optional `convertkit_form_id` + `convertkit_account`, Stripe `support_url` / `support_url_development`, `google_analytics_id`, `contact_form_action`
2. **`src/_partials/landing/`**: landing page sections (hero, steps, audience, newsletter, author card, and so on). Edit the markup in place or remove the matching landing `render` lines from `src/index.md` for sections you do not want.
3. **`src/_data/testimonials.yml`**: reader quotes (`feedback`, `highlighted_text`, optional `image_path` for site images or `image_url` for external URLs). Set `featured: true` on one entry for the spotlight; the masonry grid shows up to `testimonials_max` more (default 5 in `site_metadata.yml`).
4. **`src/images/`**: logo, favicon, `blog-og-background.png`, `og-image.png` (keep default OG paths in sync with `image` front matter on `index.md` and `guide.md`)
5. **`config/initializers.rb`**: set production `url` to your domain (`https://yourdomain.com`)
6. **`src/_guide/01-…`**: your first real content chapter at order 1 (replace or delete the sample [lesson one](/guide/lesson-one) placeholder when you are ready). Keep `00-introduction-chapter-zero.md` for local scaffold docs—it does not publish to production.

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

Use `is_coming_soon: true` for chapters you have not published yet (see [Coming soon chapters](#coming-soon)). [Lesson one](/guide/lesson-one) ships with that flag so you can preview the sidebar entry and card.

Set `hide_content_feedback: true` on a guide chapter or blog post to hide the feedback link at the bottom of the page.

Set `development_only: true` to ship a page only when `BRIDGETOWN_ENV=development` (this chapter uses that flag). Production builds drop those resources from the site, sidebar, search index, and OG output.

## Coming soon chapters {#coming-soon}

Set `is_coming_soon: true` in front matter while a chapter is still in progress. The chapter stays in the sidebar, but readers see the card below (and the newsletter prompt) instead of body content:

<%= render Guide::ComingSoon.new(site_metadata: site.data.site_metadata) %>

When you are ready to publish, remove `is_coming_soon` (or set it to `false`) and write your lesson. Customize the default copy in `src/_components/guide/coming_soon.rb` if you want different messaging.

## Site search {#site-search}

Search is powered by [bridgetown-quick-search](https://github.com/bridgetownrb/bridgetown-quick-search). The bar lives in `src/_partials/_header.erb` and indexes guide chapters, blog posts, and pages at build time into `/bridgetown_quick_search/index.json`.

### Excluding or customizing indexed content {#search-index}

Front matter on any page or collection document:

- `exclude_from_search: true` — omit from the index (used on the landing page, contact, and privacy)
- `quick_search_content: "…"` — override the text indexed for that page (defaults to rendered page content)

### Component options {#search-component-options}

The search component accepts Liquid variables (see `_header.erb` for the live config):

| Variable | Description |
| --- | --- |
| `placeholder` | Input placeholder text |
| `input_class` | CSS classes on the search input |
| `theme` | `"dark"` or `"light"` (popup theme) |
| `snippet_length` | Character length of each result snippet (default 142) |
| `display_collection` | Show which collection each result belongs to |

### Styling search results {#search-styling}

The results popup is a shadow-DOM web component. Tweak it in `frontend/styles/bridgetown-quick-search.css` with CSS variables on `bridgetown-search-results` (`--link-color`, `--divider-color`, `--text-color`, `--border-radius`) or `::part()` selectors. See the [plugin README](https://github.com/bridgetownrb/bridgetown-quick-search#styling) for details.

## Reader experience extras {#reader-extras}

These are small UX additions on top of stock Bridgetown—they ship with Chapter Zero and need no extra setup.

### Heading anchors {#heading-anchors}

`plugins/builders/heading_anchors.rb` adds a `#` link after every `h2`, `h3`, and `h4` inside `<article>` that has an `id`. Readers can click or copy a permalink to that section.

Give headings stable IDs in Markdown with Kramdown's attribute list syntax:

```markdown
## Local development {#local-development}
```

Styles live in `frontend/styles/guide-chapter.css` (`scroll-margin-top` keeps anchored headings clear of the header). Try the `#` links on headings in this chapter.

### Code copy {#code-copy}

Guide chapters and blog posts wrap prose in `data-controller="clipboard"` (`guide_chapter.erb` and `blog_post.erb`). The Stimulus controller in `frontend/javascript/controllers/clipboard_controller.js` adds a copy button to each `pre.highlight` block. Styles are in `frontend/styles/clipboard.css`. No extra markup in your Markdown—fenced code blocks with a language tag get copy buttons automatically. See [JavaScript with Stimulus](#javascript-with-stimulus) for how controllers are registered.

Try the **Copy** button on this block:

```sh
bin/setup
bin/dev
```

## Writing chapter content {#writing-content}

Guide chapters and blog posts are Markdown (Kramdown + GFM). Guide chapters can also embed components with ERB (see [Tip callouts](#tip-callouts) below). For a comprehensive set of rendered markup examples—headings, emphasis, links, lists, tables, footnotes, and more—see the sample post [Hello from the blog](/blog/hello-world/).

### Tip callouts {#tip-callouts}

Guide chapters only: render callouts with `Shared::Tip` via ERB in your `.md` file. Blog posts are plain Markdown—no ERB components.

<%= render Shared::Tip.new(
  title: "Guide-only",
  markdown: "This is a `Shared::Tip` callout. Use it for asides, warnings, or beginner-friendly notes without breaking the flow of your lesson."
) %>

In your chapter file:

```erb
<%%= render Shared::Tip.new(
  title: "Optional title",
  markdown: "Your **Markdown** body here."
) %>
```

### Code blocks {#code-blocks}

Fenced blocks with a language tag get syntax highlighting and a **copy** button (see [Code copy](#code-copy)). Example:

```ruby
class Welcome
  def self.message
    "Your first chapter goes here."
  end
end
```

For inline `` `code` ``, language-tagged fences, and more patterns, see [Inline and fenced code](/blog/hello-world/#inline-and-fenced-code) in the sample blog post.

### Blog posts {#blog-posts}

Posts live in `src/_blog/` with `layout: blog_post`, a `date`, and a `slug`. They appear on the landing page and at `/blog/`.

The shipped sample post [Hello from the blog](/blog/hello-world/) is your Markdown reference: open it in the browser to see every common element rendered, or edit `src/_blog/hello-world.md` to match your voice. It covers headings, emphasis, links, images, lists, blockquotes, code, tables, footnotes, definition lists, and abbreviations—use it when you need to check how something will look before writing a real post.

## OG images {#og-images}

Chapter and blog posts get auto-generated 1200×630 PNGs at build time (saved under `output/og/`).

### Preview in the browser {#og-preview}

During `bin/dev`, open any OG image directly in the browser by inserting `/og/` into the page URL and appending `.png`:

```
http://localhost:4000/og/guide/introduction-chapter-zero.png
```

The pattern is `/og/{collection}/{slug}.png` for `guide` and `blog` collections. Examples:

- Guide chapter: `/og/guide/introduction-chapter-zero.png` (matches [this chapter](/guide/introduction-chapter-zero/); development builds only)
- Blog post: `/og/blog/hello-world.png` (matches `/blog/hello-world/`)

In production, swap the host: `https://yourdomain.com/og/guide/your-chapter-slug.png`.

### Dynamic OG routes {#og-routes}

The `/og/…` URLs are served by a Roda route in `server/routes/og_image.rb`. During `bin/dev`, if a pre-built PNG is missing, the route generates one on the fly from `output/og/{collection}/manifest.json`.

Only collections listed in `OG_COLLECTIONS` are handled:

```ruby
OG_COLLECTIONS = %w[guide blog].freeze
```

If you add a new collection and want the same `/og/{collection}/{slug}.png` previews, add its label to `OG_COLLECTIONS` in `server/routes/og_image.rb`. For build-time PNG generation, update the matching `OG_COLLECTIONS` constant in `plugins/builders/site_og_images.rb` as well.

### Build dependencies {#og-build-dependencies}

The build needs:

- **ImageMagick** (`magick` or `convert` on PATH)
- **rsvg-convert** (librsvg)

## Deployment

```sh
bin/bridgetown deploy
```

Publish the `output/` folder. Netlify config is included in `netlify.toml`.

## Reference implementation

[minitestrails.com](https://minitestrails.com) runs a full curriculum on this shell.
