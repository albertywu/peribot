# Description
#   Subscribe to periscope users, and get notified when they GO LIVE!
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Albert Wu <albertywu@gmail.com>

{ getUserIds } = require('./utils')

module.exports = (robot) ->
  robot.hear /peribot get user ids (.+)/i, (res) ->
    userIds = res.match[1].split(',')
    getUserIds(userIds)
      .then (userIds) -> res.reply userIds.join(', ')

  robot.hear /orly/, (res) ->
    res.send sayBye()
