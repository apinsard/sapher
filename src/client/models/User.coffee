class User
  constructor: (@username, @public_key, @private_key) ->

  is_anonymous: -> @username is "anonymous"

  is_authenticated: -> @private_key isnt null

  toString: -> @username


User.anonymous = -> new User("anonymous", null, null)


module.exports = User
