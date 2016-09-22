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

{ getUserIds, followUsers, peribotSay } = require('./utils')
{ Brain } = require('./Brain')

module.exports = (robot) ->

  # Creates new instance of Brain
  periscopeUsers = new Brain(robot, 'periscopeUsers')

  robot.hear /twitter clear/, (res) ->
    res.reply "cleared brain"
    periscopeUsers.clear()

  robot.hear /twitter follow (\S+)/i, (res) ->
    userName = res.match[1]
    periscopeUsers.add userName

    res.reply "Started following #{ userName }"
    getUserIds(periscopeUsers.getAll())
      .then (userIds) ->
        followUsers userIds, (tweet) -> peribotSay robot, "#{ tweet.user.screen_name }: #{ tweet.text }", 'general'

  robot.hear /twitter following/i, (res) ->
    following = periscopeUsers.getAll()
    res.reply (
      if following.length > 0
      then "Following: #{ following.join(', ') }"
      else "Not following anyone."
    )

  robot.hear /twitter unfollow (\S+)/i, (res) ->
    userName = res.match[1]
    if userName is 'all'
      periscopeUsers.clear()
      res.reply "I am no longer following anyone."
    else
      periscopeUsers.remove userName
      res.reply "Unfollowed #{ userName }"
      getUserIds(periscopeUsers.getAll())
        .then (userIds) ->
          console.log "After twitter unfollow: #{ userIds }"
          followUsers userIds, (tweet) -> peribotSay robot, "#{ tweet.user.screen_name }: #{ tweet.text }", 'general'

  robot.hear /twitter get user ids (.+)/i, (res) ->
    userNames = res.match[1].split(',')
    getUserIds(userNames)
      .then (
        (userIds) -> res.reply userIds.join(', ')
        (err) -> res.reply err
      )
