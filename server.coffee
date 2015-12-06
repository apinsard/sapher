fs = require 'fs'
http = require 'http'
url = require 'url'


config = {}

config.global =
  server_port: 3000
  root: __dirname

config.main =
  server_name: 'sapher.dev'
  index: config.global.root + '/client/index.html'

config.www =
  server_name: 'www.sapher.dev'

config.static =
  server_name: 'static.sapher.dev'
  root: config.global.root + '/client'

config.api =
  server_name: 'api.sapher.dev'

console.log config

server = http.createServer (req, res) ->

  hostname = req.headers.host.split(':')[0]

  for cfg of config
    if config[cfg].server_name == hostname
      console.log cfg
      conf = config[cfg]

  page = (url.parse req.url).pathname

  console.log hostname, page

  if page is '/' and 'index' of conf
    fs.readFile conf.index, do (res) -> (err, data) ->
      res.writeHead 200
      res.end data
  else
    fs.readFile conf.root + page, do (res) -> (err, data) ->
      res.writeHead 200
      res.end data

server.listen config.global.server_port
