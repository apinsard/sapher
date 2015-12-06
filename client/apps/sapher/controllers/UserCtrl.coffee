define ['./module'], (controllers) ->
  controllers.controller 'UserCtrl', ($scope, User) ->
    $scope.user = new User()
