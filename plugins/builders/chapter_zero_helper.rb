class Builders::ChapterZeroHelper < SiteBuilder
  def build
    helper :show_chapter_zero_intro?
    helper :chapter_zero_intro_url
  end

  def show_chapter_zero_intro?
    Bridgetown.environment.development?
  end

  def chapter_zero_intro_url
    helpers.relative_url("/guide/introduction-chapter-zero")
  end
end
