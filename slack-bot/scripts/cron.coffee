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
    glob.jobAlarm = new cronJob(
      cronTime: "00 #{min} #{hour} * * *"
      onTick: () ->
        send '#team-mezamashi', "起きろ"
        glob.jobSnooze = new cronJob(
          cronTime: '00 * * * * *'
          onTick: () ->
            count++
            if count > 1  # snooze
              send '#team-mezamashi', "@channel 起こしてください"
          start: false
        )
      start: false
    )
    glob.jobAlarm.start()
    glob.jobSnooze.start()


  robot.hear /set\s*([0-2][0-9][:][0-5][0-9])$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "


  robot.hear /wake$/i, (msg) ->
    send '#team-mezamashi', " start:目覚ましを止めました "
    glob.jobSnooze.stop()
    glob.jobAlarm.stop()
    send '#team-mezamashi', " end:目覚ましを止めました "

