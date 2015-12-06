define [
  'require'
  'angular'
  'sapher'
  'routes'
], (require, ng) ->
  require ['domReady!'], (document) ->
    ng.bootstrap document, ['sapher']
