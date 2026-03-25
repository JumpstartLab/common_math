class Lesson < ApplicationRecord
  belongs_to :topic
  has_one :lesson_plan, dependent: :destroy
  has_one :problem_set, dependent: :destroy
  has_one :exit_ticket, dependent: :destroy
  has_one :homework, dependent: :destroy
  has_many :supplemental_resources, as: :resourceable, dependent: :destroy
  has_many :standard_taggings, as: :taggable
  has_many :standards, through: :standard_taggings

  validates :number, presence: true, uniqueness: { scope: :topic_id }
  validates :position, presence: true

  # Reconstruct the full HTML document from stored components.
  def reconstructed_html
    Engageny::HtmlParser.reconstruct(
      head_html,
      tail_html,
      lesson_plan&.content_html,
      problem_set&.content_html,
      exit_ticket&.content_html,
      homework&.content_html
    )
  end

  # Read and normalize the original source file for comparison.
  def original_normalized_html
    return nil unless source_file
    path = Rails.root.join(source_file)
    return nil unless path.exist?
    Engageny::HtmlNormalizer.normalize(File.read(path))
  end

  def label
    mod = topic.content_module
    "G#{mod.grade.number}-M#{mod.number}-T#{topic.letter}-L#{number}"
  end
end
