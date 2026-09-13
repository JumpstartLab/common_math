# Scheduled (see config/recurring.yml) weekly re-run of standards:retarget
# for every framework in Interstandard::DEFAULT_TARGETS, so demotions,
# retirements, and newly confirmed edges on the Interstandard side keep
# propagating into our StateStandardTaggings without a human running the
# rake task by hand.
class RetargetStandardsJob < ApplicationJob
  queue_as :default

  def perform(target_frameworks = Interstandard::DEFAULT_TARGETS)
    target_frameworks.each do |target_framework|
      report = Standards::Retargeter.new.call(target_framework)
      Rails.logger.info(
        "[RetargetStandardsJob] #{target_framework}: stored=#{report.stored} " \
        "no_confirmed_match=#{report.no_confirmed_match.size} invalid=#{report.invalid.size} stale=#{report.stale}"
      )
    end
  end
end
