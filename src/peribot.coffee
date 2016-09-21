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

module.exports = (robot) ->

  robot.brain.set('periscope', [])

  robot.hear /twitter follow (\S+)/i, (res) ->
    userName = res.match[1]
    filtered = robot.brain.get('periscope').filter (u) -> u isnt userName
    filtered.push userName
    robot.brain.set 'periscope', filtered

    res.reply "Started following #{ userName }"
    getUserIds(robot.brain.get('periscope'))
      .then (userIds) ->
        followUsers userIds, (tweet) -> peribotSay robot, "#{ tweet.user.screen_name }: #{ tweet.text }", 'general'

  robot.hear /twitter following/i, (res) ->
    following = robot.brain.get('periscope')
    res.reply (
      if following.length > 0
      then "Following: #{ following.join(', ') }"
      else "Not following anyone."
    )

  robot.hear /twitter unfollow (\S+)/i, (res) ->
    userName = res.match[1]
    if userName is 'all'
      robot.brain.set('periscope', [])
      res.reply "I am no longer following anyone."
    else
      filtered = robot.brain.get('periscope').filter (u) -> u isnt userName
      robot.brain.set 'periscope', filtered

      res.reply "Unfollowed #{ userName }"
      getUserIds(robot.brain.get('periscope'))
        .then (userIds) ->
          followUsers userIds, (tweet) -> peribotSay robot, "#{ tweet.user.screen_name }: #{ tweet.text }", 'general'


  robot.hear /twitter get user ids (.+)/i, (res) ->
    userNames = res.match[1].split(',')
    getUserIds(userNames)
      .then (
        (userIds) -> res.reply userIds.join(', ')
        (err) -> res.reply err
      )

