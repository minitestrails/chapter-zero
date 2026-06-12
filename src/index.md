---
layout: default
image:
  path: /images/og-image.png
  width: 1200
  height: 630
---

<%= render "landing/hero" %>
<%= render "landing/featured_testimonial" %>
<%= render "landing/how_it_works" %>
<%= render "landing/audience" %>
<%= render "landing/featured_chapters" %>
<%= render "landing/testimonials" %>
<%= render "landing/newsletter" %>
<%= render "landing/blog_posts" %>

<section id="about-the-author" class="py-20 px-6 scroll-mt-6" aria-labelledby="about-the-author-heading">
  <div class="max-w-3xl mx-auto">
    <%= render "landing/author_card" %>
  </div>
</section>
