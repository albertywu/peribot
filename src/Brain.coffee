class Brain

  # (robot: Hubot, root: string)
  constructor: (@robot, @root) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data[@root]
        @robot.logger.info "Found Redis data, so caching robot.brain.data.#{@root}"
        @robot.logger.info JSON.stringify(@robot.brain.data[@root])
        @cache = @robot.brain.data[@root]

  # (value: number|string)
  add: (value) ->
    idx = @cache.indexOf value
    if idx is -1
      @cache.push value
    @robot.brain.data[@root] = @cache

  # (value: number|string)
  remove: (value) ->
    idx = @cache.indexOf value
    if idx > -1
      @cache.splice(idx, 1)
    @robot.brain.data[@root] = @cache

  # (void) => (number|string)[]
  getAll: -> @cache

  clear: ->
    @cache = []
    @robot.brain.data[@root] = @cache

module.exports = {
  Brain
}