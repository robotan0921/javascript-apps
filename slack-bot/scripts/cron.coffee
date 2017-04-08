# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob
jobAlarm = null
jobSnooze = null
count = 0
snooze = 1


module.exports = (robot) ->


  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg


  setTime = (time) ->
    match = /(\d+)\D+(\d+)/.exec(time)
    min = match[2]
    hour = match[1]
    jobAlarm = new cronJob("00 #{min} #{hour} * * *", () ->
      send '#team-mezamashi', "@here そろそろ帰る準備をしよう"
      jobSnooze = new cronJob('00 * * * * *', () ->
        count++
        if count > snooze
          send '#team-mezamashi', "@channel Wake me up!!"
      ).start()
    ).start()
    send '#team-mezamashi', "match:#{match}"
    send '#team-mezamashi', "hour:#{hour}, min:#{min}"


  robot.hear /set\s*(\d[:]\d\d)$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "


  robot.hear /wake$/i, (msg) ->
    jobAlarm.stop()
    jobSnooze.stop();
    send '#team-mezamashi', " 目覚ましを止めました "

