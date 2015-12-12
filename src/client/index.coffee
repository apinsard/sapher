# h = require 'virtual-dom/h'
# diff = require 'virtual-dom/diff'
# patch = require 'virtual-dom/patch'
# createElement = require 'virtual-dom/create-element'

openpgp = require 'openpgp'

User = require './models/User'

if typeof Storage is 'undefined'
  console.err "Storage not available!"
  return
console.info "Storage available? YES"

if not localStorage.user__username
  console.debug "Creating anonymous user"
  user = User.anonymous()
  localStorage.user__username = user.username
  localStorage.user__public_key = user.public_key
  localStorage.user__private_key = user.private_key
else
  user = new User localStorage.user__username,
                  localStorage.user__public_key,
                  localStorage.user__private_key

console.debug "User is: #{user}"

signIn = (username, password) ->

signUp = (username, password) ->
  # 1. Generate key pair
  openpgp.generateKeyPair
    numBits: 2048
    userId: "#{username} <#{username}@sapher.dev>"
    passphrase: password
  .then (keypair) ->
    console.log "Keypair generated"
    console.info keypair
  .catch (error) ->
    console.log "An error occured"
    console.error error

signOut = ->
  delete localStorage.user__username
  delete localStorage.user__public_key
  delete localStorage.user__private_key
  user = User.anonymous()

console.log "What are you up to?"
if user.is_anonymous()
  console.log "1. signIn(username, password)"
  console.log "2. signUp(username, password)"
  window.signIn = signIn
  window.signUp = signUp
else
  console.log "1. signOut()"
  window.signOut = signOut
