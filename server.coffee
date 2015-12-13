fs = require 'fs'
http = require 'http'
url = require 'url'

class Config

  constructor: (@value={}) ->

  get: (key) ->
    if key of @value
      value = @value[key]
    else if @value.inherits?
      value = @value.inherits.get key
    else
      value = undefined
    @parse value

  has: (key) -> (@get key) isnt undefined

  parse: (value) ->
    if typeof value is 'function' and value.is_configSuper
      value @value.inherits
    else
      value

  satifies: (req) ->
    selector = @get 'selector'
    if typeof selector isnt 'function'
      false
    else
      selector.bind(this)(req)

Config.super = (property, transform) ->
  configSuper = (config) -> transform config.get property
  configSuper.is_configSuper = true
  configSuper


config =
  global: new Config
    server_name: '127.0.53.53'
    server_port: 3000
    root: __dirname
    selector: (req) ->
      'host' of req.headers &&
        (req.headers.host.split ':')[0] is @get 'server_name'

config.main = new Config
  inherits: config.global
  server_name: 'sapher.dev'
  index: Config.super 'root', (value) -> value + '/static/index.html'

config.www = new Config
  inherits: config.global
  server_name: 'www.sapher.dev'
  redirect_to: 'sapher.dev'

config.static = new Config
  inherits: config.global
  server_name: 'static.sapher.dev'
  root: Config.super 'root', (value) -> value + '/static'

config.api = new Config
  inherits: config.global
  server_name: 'api.sapher.dev'

config.default = new Config
  inherits: config.global
  selector: (req) -> true
  root: undefined


server = http.createServer (req, res) ->

  # Parse host
  host = req.headers.host
  if host
    [hostname, port] = host.split(':')
  hostname ?= config.global.get 'server_name'
  port ?= config.global.get 'server_port'
  protocol = 'http'

  # Load config
  for cfg of config
    if config[cfg].satifies req
      conf = config[cfg]
      break
  conf ?= config.default

  # Parse URI
  page = (url.parse req.url).pathname
  console.log page

  if conf.has 'redirect_to'
    res.writeHead 301,
      'Location': "#{protocol}://#{conf.get 'redirect_to'}:#{port}#{page}"
    res.end()
  else if page is '/' and conf.has 'index'
    fs.readFile (conf.get 'index'), do (res) -> (err, data) ->
      res.writeHead 200
      res.end data
  else if conf.has 'root'
    fs.readFile (conf.get 'root') + page, do (res) -> (err, data) ->
      res.writeHead 200
      res.end data
  else
    res.writeHead 404
    res.end 'Not found'

server.listen config.global.get 'server_port', config.global.get 'server_name'
