module StateStandardsHelper
  # Path to a StateStandardTagging's taggable (a Lesson or a Topic) in the
  # existing nested grade/module/topic/lesson browse hierarchy.
  def taggable_path(taggable)
    case taggable
    when Lesson
      topic = taggable.topic
      content_module = topic.content_module
      grade_content_module_topic_lesson_path(content_module.grade, content_module, topic, taggable)
    when Topic
      content_module = taggable.content_module
      grade_content_module_topic_path(content_module.grade, content_module, taggable)
    end
  end

  def taggable_label(taggable)
    case taggable
    when Lesson then taggable.label
    when Topic then "Topic #{taggable.letter}: #{taggable.title}"
    end
  end
end
