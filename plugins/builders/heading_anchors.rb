# Adds a "#" link to h2, h3, h4 that have an id so users can copy a permalink to that section.
# Requires nokogiri or nokolexbor in the Gemfile (uncomment one and run bundle install).
# See: https://www.bridgetownrb.com/docs/plugins/inspectors

class Builders::HeadingAnchors < SiteBuilder
  def build
    inspect_html do |document|
      document.query_selector_all("article h2[id], article h3[id], article h4[id]").each do |heading|
        heading << document.create_text_node(" ")
        heading << document.create_element(
          "a", "#",
          href: "##{heading[:id]}",
          class: "heading-anchor"
        )
      end
    end
  end
end
