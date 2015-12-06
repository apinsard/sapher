define [
  'angular'
  'angular-route'
  './controllers/index'
  # './directives/index'
  # './filters/index'
  './models/index'
  # './services/index'
], (ng) ->
  ng.module 'sapher', [
    'sapher.controllers'
    # 'sapher.directives'
    # 'sapher.filters'
    'sapher.models'
    # 'sapher.services'
    'ngRoute'
  ]
