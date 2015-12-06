define ['./module'], (models) ->
  models.factory 'User', ->
    class User
      constructor: (options) ->
        @isAnonymous = false
        @isAuthenticated = true
        @name = "Lilarcor"
    return User
