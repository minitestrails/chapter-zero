---
title: Blog
layout: default
---

<% blog_resources = site.collections["blog"]&.resources || [] %>
<% blog_resources = blog_resources.sort_by { |r| r.data.date || "" }.reverse %>

<%= render Shared::CollectionHeader.new(
      title: data.title,
      description: "Notes and updates that do not fit in a single guide chapter."
    ) %>

<div class="max-w-6xl mx-auto px-4 py-10 sm:py-12">
  <% if blog_resources.empty? %>
    <div class="alert alert-info">
      <span>Posts are on the way. <a href="<%= relative_url '#newsletter' %>" class="link link-hover underline">Subscribe to the newsletter</a> to receive an email when new ones land.</span>
    </div>
  <% else %>
    <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
      <% blog_resources.each do |post| %>
        <%= render Blog::PostCard.new(post: post) %>
      <% end %>
    </div>
  <% end %>
</div>
