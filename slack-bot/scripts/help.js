// Description:
//   Hubotのhelpコマンドを生成
//
// Commands:
//   hubot help           - コマンドの一覧を表示
//   hubot help <command> - コマンドの検索結果を表示

var table = require('easy-table');

module.exports = function(robot) {
  var NIL_MSG = '結果はありません。';

  robot.respond(/help\s*(.+)?$/i, function(msg) {
    var cmds = robot.helpCommands();
    var filter = msg.match[1];
    var results = [];
    var t = new table;

    if (filter) {
      cmds.forEach(function(cmd, _) {
        if (!cmd.match(new RegExp(filter, 'i'))) {
          return;
        }
        results.push(cmd);
      });

      if (results.length === 0) {
        return msg.reply(NIL_MSG);
      }
    } else {
      results = cmds;
    }

    results.forEach(function(cmd, _) {
      cmd = cmd.replace(/^hubot/i, robot.name.toLowerCase());
      arr = cmd.split(' - ');

      t.cell('Command', arr[0]);
      t.cell('Description', arr[1]);
      t.newRow();
    });

    if (t.rows.length > 0) {
      return msg.reply("```\n" + (t.print().trim()) + "\n```");
    }

    return msg.reply(NIL_MSG);
  });
};
