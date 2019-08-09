env :PATH, ENV['PATH']

every 1.day, at: '6:59 am' do
  runner "DailyDigestJob.perform_now"
end

every 30.minutes do
  rake "ts:index"
end

# Learn more: http://github.com/javan/whenever
