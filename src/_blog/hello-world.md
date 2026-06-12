---
title: Hello from the blog
description: A Markdown reference post—headings, lists, code, tables, and more as rendered by Chapter Zero.
date: 2026-06-01
layout: blog_post
slug: hello-world
tags:
  - chapter-zero
  - markdown
  - sample
---

This post is a **living reference** for Markdown in guide chapters and blog posts. If you are unsure how something will look, check the rendered output here first.

Posts live in `src/_blog/` with `layout: blog_post`, a `date`, and a `slug`. Guide chapters use the same Markdown features inside `src/_guide/`.

## Headings {#headings}

Use `##` through `######` for section headings. Add a custom ID with Kramdown attribute syntax: `## Headings {#headings}` (this section uses that—hover the `#` link).

### Third level

#### Fourth level

##### Fifth level

###### Sixth level

## Text emphasis

Regular paragraph with **bold**, *italic*, ***bold italic***, and ~~strikethrough~~ (GFM).

Combine them in one sentence: **bold with *nested italic*** and `inline code`.

## Links

- Inline link to the [introduction chapter](/guide/introduction-chapter-zero/) (development builds only)
- External link to [Bridgetown](https://www.bridgetownrb.com/)
- Reference-style link to the [blog index][blog]

[blog]: /blog/

## Images

![Chapter Zero logo](/images/logos/logo.png)

## Lists

Unordered:

- First item
- Second item
  - Nested item
  - Another nested item
- Third item

Ordered:

1. Step one
2. Step two
   1. Sub-step A
   2. Sub-step B
3. Step three

## Blockquotes

> A single-line quote.
>
> A multi-line quote with **emphasis** and a [link](/guide/).
>
> > Nested blockquote.

## Inline and fenced code

Run `bin/setup` then `bin/dev`. Fenced blocks get syntax highlighting and a copy button:

```ruby
class Example
  def greet
    "Hello from Chapter Zero"
  end
end
```

```sh
bin/setup
bin/dev
```

```javascript
import { Application } from "@hotwired/stimulus"

window.Stimulus = Application.start()
```

```css
.prose pre {
  overflow-x: auto;
}
```

Indented code block (no language tag):

    def legacy_style
      :still_works
    end

## Horizontal rule

Content above the rule.

---

Content below the rule.

## Tables

| Feature | Guide | Blog |
| --- | --- | --- |
| Sidebar | Yes | No |
| `layout` | `guide_chapter` | `blog_post` |
| OG image | `/og/guide/{slug}.png` | `/og/blog/{slug}.png` |

Alignment (GFM):

| Left | Center | Right |
| :--- | :---: | ---: |
| A | B | C |
| longer cell text | mid | 42 |

## Footnotes

Kramdown supports footnotes.[^fn-example]

[^fn-example]: This note appears at the bottom of the rendered page.

## Definition lists

Kramdown definition list:

Markdown
: A lightweight markup language for plain-text documents.

Front matter
: YAML metadata at the top of a file, between `---` delimiters.

## Abbreviations

The HTML specification is maintained by the W3C.

*[HTML]: Hyper Text Markup Language
*[W3C]: World Wide Web Consortium

## What's not plain Markdown

- **Tip callouts** (`Shared::Tip`) — render via ERB in guide Markdown only; see the introduction chapter.
- **Heading `#` permalinks** — added automatically by `plugins/builders/heading_anchors.rb` on `h2`–`h4` with IDs.
- **Code copy buttons** — added by the Stimulus `clipboard` controller on guide and blog prose.

When you are ready, replace this file with your own posts or keep it as an internal style reference.
