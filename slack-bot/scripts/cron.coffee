# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->
  robot.brain.data[min] = 0
  robot.brain.data[hour] = 0

  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg


  setTime = (time) ->
    match = /(\d+)\D+(\d+)/.exec(time)
    robot.brain.data[min] = match[2]
    robot.brain.data[hour] = match[1]
    send '#team-mezamashi', "match:#{match}"
    send '#team-mezamashi', "hour:#{hour}, min:#{min}"


  robot.hear /set\s*(\d[:]\d\d)$/i, (msg) ->
    time = msg.match[1].trim()
    setTime time
    send '#team-mezamashi', " 目覚ましを " + time + " にセットしました "


  # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  # #your_channelと言う部屋に、平日の18:30時に実行
  new cronJob('00 robot.brain.data[min] robot.brain.data[hour] * * *', () ->
    # ↑のほうで宣言しているsendメソッドを実行する
    send '#team-mezamashi', "@here そろそろ帰る準備をしよう"
  ).start()

  # #your_channelと言う部屋に、平日の13:00時に実行
  new cronJob('13 * * * * *', () ->
    send '#team-mezamashi', "@here ランチの時間だよ！！"
  ).start()