class Builders::SupportUrlHelper < SiteBuilder
  def build
    helper :support_url
  end

  def support_url
    site_metadata = helpers.site.data.site_metadata

    url = if ENV["BRIDGETOWN_ENV"] == "development"
      site_metadata.support_url_development
    else
      site_metadata.support_url
    end

    url.to_s.strip.empty? ? nil : url.to_s
  end
end
