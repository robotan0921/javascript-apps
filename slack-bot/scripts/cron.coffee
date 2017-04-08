# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob
jobAlarm = null
jobSnooze = null
count = 0
snooze = 1


module.exports = (robot) ->



  send = (channel, msg) ->
    robot.send {room: channel}, msg


  setTime = (time) ->
    match = /(\d+)\D+(\d+)/.exec(time)
    min = match[2]
    hour = match[1]
    jobAlarm = new cronJob("00 #{min} #{hour} * * *", () ->
      send '#team-mezamashi', "起きろ"
      jobSnooze = new cronJob('00 * * * * *', () ->
        count++
        if count > snooze
          send '#team-mezamashi', "@channel 起こしてくーださい"
      ).start()
    ).start()


  robot.hear /set\s*([0-2][0-9][:][0-5][0-9])$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "


  robot.hear /wake$/i, (msg) ->
    jobAlarm.stop()
    jobSnooze.stop()
    send '#team-mezamashi', " 目覚ましを止めました "

