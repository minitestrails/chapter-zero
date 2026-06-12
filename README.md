# Chapter Zero

**Chapter Zero** is the Bridgetown starter for technical guides. Scaffolding before your first real chapter.

It is the foundational setup you need before diving into actual content: a landing page, ordered chapters with a sidebar, blog, contact form, newsletter slot, support banner, and auto-generated social preview images. Like "chapter 0" in a book, it is the starting point. You bring the lessons.

[minitestrails.com](https://minitestrails.com) runs a full curriculum on this shell.

## Quickstart

```sh
git clone https://github.com/minitestrails/chapter-zero.git
cd chapter-zero
bundle install && npm install
cp .env.sample .env
bin/dev
```

Copy `.env.sample` to `.env` so Bridgetown runs in development mode locally (`BRIDGETOWN_ENV=development`). That keeps analytics off and uses your dev Stripe support link when configured.

Open [http://localhost:4000](http://localhost:4000) (override with `PORT` if needed).

After setup, customize site metadata and landing partials below, then add your curriculum starting at `src/_guide/02-your-topic.md`. `/guide/lesson-one` ships as a **coming soon** placeholder so you can see how unpublished chapters look in the sidebar. The same content lives in the [introduction chapter](https://minitestrails.com/guide/introduction) on the built site.

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

## Bridgetown

Chapter Zero is a static site built with [Bridgetown](https://www.bridgetownrb.com/). Collections (`guide`, `blog`), layouts, partials, plugins, and `bin/bridgetown deploy` all follow Bridgetown conventions.

For configuration, content model, and deployment details, use the official documentation: [bridgetownrb.com/docs](https://www.bridgetownrb.com/docs).

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
6. **`src/_guide/02-…`**: your first real content chapter (keep `00-introduction.md`; replace or delete the sample lesson-one placeholder when you are ready)

Set `show_chapter_zero_credit: false` in `site_metadata.yml` if you do not want the footer link to [minitestrails.com/chapter-zero](https://minitestrails.com/chapter-zero).

Run `bin/dev` and preview at [http://localhost:4000](http://localhost:4000) after each batch of changes.

## Architecture

UI is **component-first**: Ruby classes in `src/_components/` with DaisyUI classes in matching `.erb` templates. Shared chrome (header, footer, support banner) and landing sections (`src/_partials/landing/`) keep pages and layouts small.

Guide chapters are Markdown in `src/_guide/` with front matter like:

```yaml
title: Your chapter title
description: One line for cards and OG images
order: 2
layout: guide_chapter
slug: your-url-segment
featured: true  # optional; show on the landing page featured chapters section (sorted by order)
hide_content_feedback: true  # optional; omit or set false to show the feedback link
```

The `slug` becomes `/guide/your-url-segment/`. `order` controls sidebar sort and featured chapter order on the landing page.

Use `is_coming_soon: true` for chapters you have not published yet: readers see the coming-soon card and newsletter prompt instead of body content (see `/guide/lesson-one`).

Set `hide_content_feedback: true` on a guide chapter or blog post to hide the feedback link at the bottom of the page.

## Writing chapter content

### Tip callouts

Render callouts with `Shared::Tip` in guide Markdown via ERB. In `.erb` files use a single `%`; in guide Markdown escape as `%%` so Bridgetown does not evaluate at build time.

### Code blocks

Use fenced blocks with a language tag:

```ruby
class Example
  def greet
    "Hello from your guide"
  end
end
```

### Blog posts

Posts live in `src/_blog/` with `layout: blog_post`, a `date`, and a `slug`. They appear on the landing page and at `/blog`.

## OG image build dependencies

Chapter and blog posts can get auto-generated PNGs under `output/og/`. The build needs:

- **ImageMagick** (`magick` or `convert` on PATH)
- **rsvg-convert** (librsvg)

## Deployment

```sh
bin/bridgetown deploy
```

Publish the `output/` folder. Netlify config is included in `netlify.toml`.

## License

MIT. See [LICENSE](LICENSE).
