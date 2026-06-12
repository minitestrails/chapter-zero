# Drops resources with `development_only: true` from the site in non-development builds.
# Used for chapter 0 (scaffold docs) so production sites only ship real curriculum.
class Builders::DevelopmentOnlyContent < SiteBuilder
  def build
    hook :site, :post_read do |site|
      next if Bridgetown.environment.development?

      site.collections.each_value do |collection|
        collection.resources.reject! { |resource| resource.data.development_only }
      end
    end
  end
end
