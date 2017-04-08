# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob
job = null

module.exports = (robot) ->


  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg


  setTime = (time) ->
    match = /(\d+)\D+(\d+)/.exec(time)
    min = match[2]
    hour = match[1]
    job = new cronJob("00 #{min} #{hour} * * *", () ->
      send '#team-mezamashi', "@here そろそろ帰る準備をしよう"
    ).start()
    send '#team-mezamashi', "match:#{match}"
    send '#team-mezamashi', "hour:#{hour}, min:#{min}"


  robot.hear /set\s*(\d[:]\d\d)$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "




  # #your_channelと言う部屋に、平日の13:00時に実行
  new cronJob('13 * * * * *', () ->
    send '#team-mezamashi', "@here ランチの時間だよ！！"
  ).start()