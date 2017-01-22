# Description:
#   Hubotのhelpコマンドを生成
#
# Commands:
#   hubot <user> ++ - ユーザのスコアをインクリメント
#   hubot <user> -- - ユーザのスコアをデクリメント
#   hubot score     - スコアのランキングを表示

table = require('easy-table')

module.exports = (robot) ->
  NIL_MSG = '結果はありません。'

  robot.hear /(.+)\s*\+\+$/i, (msg) ->
    user = msg.match[1].trim()
    score = (getScores()[user] ? 0) + 1
    setScore(user, score)
    msg.send("#{user} さんのスコアが #{score} になりました!")

  robot.hear /(.+)\s*--$/i, (msg) ->
    user = msg.match[1].trim()
    score = (getScores()[user] ? 0) - 1
    score = 0 if score < 0
    setScore(user, score)
    msg.send("#{user} さんのスコアが #{score} になりました!")

  robot.respond /score$/i, (msg) ->
    scores = for user, score of getScores()
      { user: user, score: score }
    scores.sort (a, b) ->
      return -1 if a.score > b.score
      return 1 if a.score < b.score
      return 0
    t = new table
    for item in scores
      t.cell('User', item.user)
      t.cell('Score', item.score)
      t.newRow()
    if t.rows.length > 0
      return msg.reply("```\n#{t.print().trim()}\n```")
    msg.reply(NIL_MSG)

  getScores = () ->
    robot.brain.get('scores') ? {}

  setScore = (user, score) ->
    scores = getScores()
    scores[user] = score
    robot.brain.set('scores', scores)
