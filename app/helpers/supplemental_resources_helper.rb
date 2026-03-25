module SupplementalResourcesHelper
  RESOURCE_LABELS = {
    "video" => "Video",
    "homework_solutions" => "HW Solutions",
    "exit_ticket_solutions" => "ET Solutions",
    "topic_quiz" => "Topic Quiz",
    "parent_newsletter" => "Parent Newsletter",
    "google_slides" => "Slides",
    "geogebra" => "GeoGebra",
    "lesson_pdf" => "Lesson PDF",
    "application_problems" => "Application Problems",
    "mid_module_review" => "Mid-Module Review",
    "end_module_review" => "End-of-Module Review",
    "pacing_guide" => "Pacing Guide",
    "fluency_games" => "Fluency Games",
    "vocabulary" => "Vocabulary",
    "number_talks" => "Number Talks",
    "downloadable_resources" => "Downloads",
    "eureka_essentials" => "Eureka Essentials",
    "khan_practice" => "Khan Academy"
  }.freeze

  # Resource types worth showing as external links.
  # Excludes proprietary formats (flipcharts, SMARTboard) and platform-dependent (GoFormative).
  DISPLAYABLE_TYPES = %w[
    video
    homework_solutions
    exit_ticket_solutions
    google_slides
    geogebra
    topic_quiz
    parent_newsletter
    application_problems
    mid_module_review
    end_module_review
    pacing_guide
    fluency_games
    vocabulary
    number_talks
    eureka_essentials
    downloadable_resources
    khan_practice
  ].freeze

  def supplemental_label(resource)
    RESOURCE_LABELS[resource.resource_type] || resource.title
  end

  def supplemental_url(resource)
    resource.url || resource.source_page_url
  end

  def displayable_supplemental_resources(resources)
    resources
      .select { |r| r.resource_type.in?(DISPLAYABLE_TYPES) && supplemental_url(r).present? }
      .sort_by { |r| DISPLAYABLE_TYPES.index(r.resource_type) || 999 }
  end

  def youtube_video_id(url)
    return nil unless url
    match = url.match(%r{(?:embed/|v=|youtu\.be/)([^&?/]+)})
    match[1] if match
  end
end
