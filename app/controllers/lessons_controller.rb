class LessonsController < ApplicationController
  def show
    @grade = Grade.find(params[:grade_id])
    @content_module = @grade.content_modules.find(params[:content_module_id])
    @topic = @content_module.topics.find(params[:topic_id])
    @lesson = @topic.lessons.includes(:lesson_plan, :problem_set, :exit_ticket, :homework).find(params[:id])
  end

  # GET /lessons/:id/reconstructed
  # Render the full reconstructed HTML with page-like styling.
  def reconstructed
    lesson = Lesson.includes(:lesson_plan, :problem_set, :exit_ticket, :homework).find(params[:id])
    html = inject_page_styles(lesson.reconstructed_html)
    render html: html.html_safe, layout: false
  end

  # GET /lessons/:id/component?type=lesson_plan|problem_set|exit_ticket|homework
  # Render a single component as a standalone page.
  def component
    lesson = Lesson.includes(:lesson_plan, :problem_set, :exit_ticket, :homework).find(params[:id])
    component_type = params[:type]

    section_html = case component_type
    when "lesson_plan"  then lesson.lesson_plan&.content_html
    when "problem_set"  then lesson.problem_set&.content_html
    when "exit_ticket"  then lesson.exit_ticket&.content_html
    when "homework"     then lesson.homework&.content_html
    else
      return head :bad_request
    end

    return head :not_found unless section_html

    full_html = Engageny::HtmlParser.wrap_section(lesson.head_html, section_html)
    render html: inject_page_styles(full_html).html_safe, layout: false
  end

  # GET /lessons/:id/pdf
  # Render the full lesson as a print-ready PDF.
  def pdf
    lesson = Lesson.includes(:lesson_plan, :problem_set, :exit_ticket, :homework).find(params[:id])
    html = lesson.reconstructed_html
    pdf_bytes = Engageny::PdfRenderer.render(html)

    send_data pdf_bytes,
      filename: "#{lesson.label}.pdf",
      type: "application/pdf",
      disposition: "inline"
  end

  private

  # Inject our page-rendering stylesheet into the Aspose HTML and add body class.
  def inject_page_styles(html)
    page_css = Rails.root.join("app/assets/stylesheets/engageny_pages.css").read
    style_tag = "<style>#{page_css}</style>"

    html
      .sub("</head>", "#{style_tag}</head>")
      .sub("<body", '<body class="engageny-pages"')
  end
end
