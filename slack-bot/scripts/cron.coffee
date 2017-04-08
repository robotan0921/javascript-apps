# # 定期処理をするオブジェクトを宣言
# cronJob = require('cron').CronJob

# module.exports = (robot) ->

#   # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
#   send = (channel, msg) ->
#     robot.send {room: channel}, msg

#   # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
#   # #your_channelと言う部屋に、平日の18:30時に実行
#   new cronJob('5 * * * * *', () ->
#     # ↑のほうで宣言しているsendメソッドを実行する
#     send '#team-mezamashi', "@here そろそろ帰る準備をしよう"
#   ).start()

#   # #your_channelと言う部屋に、平日の13:00時に実行
#   new cronJob('13 * * * * *', () ->
#     send '#team-mezamashi', "@here ランチの時間だよ！！"
#   ).start()