Accounts.ui.config {
  passwordSignupFields: 'USERNAME_AND_EMAIL'
}

Session.setDefault 'postId', null
Session.setDefault 'username', null
Session.setDefault 'file', null
Session.setDefault 'fileReady', null
Session.setDefault 'away', false
Session.setDefault 'loaded', false

Meteor.startup ->
  filepicker.setKey 'Ay0CJr5oZQi6jI6mzQTbgz'
  $('body').spin('modal')

globalSubscriptionHandles = []
globalSubscriptionHandles.push Meteor.subscribe 'userPresence'
globalSubscriptionHandles.push Meteor.subscribe 'jungle'
globalSubscriptionHandles.push Meteor.subscribe 'directory'
globalSubscriptionHandles.push Meteor.subscribe 'friends'
globalSubscriptionHandles.push Meteor.subscribe 'pins'

@resetAwayTimer = ->
  Session.set 'away', false
  setAwayTimer()

@setAwayTimer = _.debounce ->
    Session.set 'away', true
, 300000 # 5 minutes

@signedIn = ->
  if not Meteor.user()
    $.bootstrapGrowl "Please sign-in first!", { type: 'error' }
    return false
  return true

Deps.autorun ->
  isReady = globalSubscriptionHandles.every( (handle) ->
    handle.ready()
  )
  if isReady and not Session.get 'loaded'
    # switch off the spinner
    $('body').spin('modal')
    Session.set 'loaded', true
