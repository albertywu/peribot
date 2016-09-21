Promise = require('promise')
T = new require('twit')({
  consumer_key:         'Y4tuFVA36N7WDwPK1PIqbKGuk',
  consumer_secret:      'HQdsoCB2IoU0JVvstMDyhNSiXwyqrq0ynLyJXqdm9Ndbd9vUpg',
  access_token:         '15260560-5iknUZ4hUgx5CgWr5Tlbmoo8whpjizZogWOPANa2H',
  access_token_secret:  'PjT6HlfgrvT1rhOD8PFgoDGdlL0w7pz5L1bvZLMGKh1L6'
})

# (userNames: string[]) => Promise<number[]>
getUserIds = (userNames) ->
  return new Promise (resolve, reject) ->
    T.get 'users/lookup', { screen_name: userNames }, (err, data, resp) ->
      if err
        reject 'Something went wrong in GET /users/lookup'
      else
        resolve data.map (user) -> user.id

# (userIds: number[], onTweet: (tweet) => any) => Stream
followUsers = (userIds, onTweet) ->
  stream = T.stream 'statuses/filter', { follow: userIds }
  stream.removeListener 'tweet', -> return
  stream.on 'tweet', onTweet

# (robot: Hubot, msg: string, channel: string) => void
peribotSay = (robot, msg, channel) ->
  data = JSON.stringify
    username   : "peribot"
    icon_url   : "https://emoji.slack-edge.com/T0339440S/periscope/fa2fb6e3f1c0c877.png"
    channel    : "#" + channel
    text       : msg
  robot.http('https://hooks.slack.com/services/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').post(data)


module.exports = {
  getUserIds,
  followUsers,
  peribotSay
}