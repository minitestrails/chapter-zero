---
title: Guide
layout: default
image:
  path: /images/og-image.png
  alt: Chapter Zero guide
  width: 1200
  height: 630
---

<% site_metadata = site.data.site_metadata %>
<% guide_resources = site.collections["guide"]&.resources || [] %>
<% guide_resources = guide_resources.sort_by { |r| (r.data.order || 0).to_i } %>

<%= render Shared::CollectionHeader.new(
      title: data.title,
      description: "Ordered chapters with a sidebar. Replace the sample content in src/_guide/ with your curriculum."
    ) %>

<div class="max-w-6xl mx-auto px-4 py-10 sm:py-12">
  <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
    <% guide_resources.each do |chapter| %>
      <%= render Guide::ChapterCard.new(chapter: chapter) %>
    <% end %>
  </div>
</div>

<% unless site_metadata.hide_suggest_topic %>
  <div class="mb-12">
    <%= render Guide::SuggestTopic.new %>
  </div>
<% end %>
