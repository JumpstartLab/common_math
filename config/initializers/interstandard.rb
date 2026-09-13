# Configuration for the Interstandard translator API this app retargets
# CCSS taggings against. See lib/interstandard/client.rb and
# lib/tasks/standards.rake (standards:retarget, standards:retarget_all).
module Interstandard
  # No trailing slash.
  BASE_URL = ENV.fetch("INTERSTANDARD_URL", "https://interstandard.jumpstartlab.com")

  # Set in production/staging secrets; standards:retarget raises a clear
  # error if this is blank when it actually tries to call out.
  API_KEY = ENV["INTERSTANDARD_API_KEY"]

  # standards:retarget_all iterates this list unless a target is given.
  DEFAULT_TARGETS = ENV.fetch("INTERSTANDARD_TARGETS", "co-math-2020,tx-teks-math")
    .split(",").map(&:strip).reject(&:blank?).freeze

  # The CCSS framework slug our own Standard rows are tagged against.
  SOURCE_FRAMEWORK = "ccss-math".freeze
end
