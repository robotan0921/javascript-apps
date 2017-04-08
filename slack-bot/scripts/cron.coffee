# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob
glob = this
glob.jobAlarm = null
glob.jobSnooze = null

module.exports = (robot) ->



  send = (channel, msg) ->
    robot.send {room: channel}, msg


  setTime = (time) ->
    match = /(\d+)\D+(\d+)/.exec(time)
    min = match[2]
    hour = match[1]
    glob.jobAlarm = new cronJob("00 #{min} #{hour} * * *", () ->
      send '#team-mezamashi', "起きろ"
      glob.jobSnooze = new cronJob('00 * * * * *', () ->
        count++
        if count > 1  # snooze
          send '#team-mezamashi', "@channel 起こしてくーださい"
      ).start()
    ).start()


  robot.hear /set\s*([0-2][0-9][:][0-5][0-9])$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "


  robot.hear /wake$/i, (msg) ->
    glob.jobSnooze.stop()
    glob.jobAlarm.stop()
    send '#team-mezamashi', " 目覚ましを止めました "

