Accounts.ui.config {
  passwordSignupFields: 'USERNAME_AND_EMAIL'
}

Session.setDefault 'postId', null
Session.setDefault 'username', null
Session.setDefault 'file', null
Session.setDefault 'fileReady', null

Meteor.startup ->
  filepicker.setKey 'Ay0CJr5oZQi6jI6mzQTbgz'

Meteor.subscribe 'userPresence'
Meteor.subscribe 'jungle'
Meteor.subscribe 'directory'
Meteor.subscribe 'friends'
Meteor.subscribe 'pins'

@setAwayTimeout = ->
  Session.set 'away', false
  Meteor.setTimeout ->
    Session.set 'away', true
  , 300000 # 5 minutes

setAwayTimeout()

@signedIn = ->
  if not Meteor.user()
    alert "Please sign-in first"
    return false
  return true