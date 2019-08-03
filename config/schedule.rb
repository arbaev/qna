every 1.day, at: '6:59 am' do
  runner "DailyDigestJob.perform_now"
end

# Learn more: http://github.com/javan/whenever
