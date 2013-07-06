Accounts.ui.config {
  passwordSignupFields: 'USERNAME_AND_EMAIL'
}

Session.setDefault 'postId', null
Session.setDefault 'username', null
Session.setDefault 'file', null
Session.setDefault 'fileReady', null
Session.setDefault 'away', false

Meteor.startup ->
  filepicker.setKey 'Ay0CJr5oZQi6jI6mzQTbgz'

Meteor.subscribe 'userPresence'
Meteor.subscribe 'jungle'
Meteor.subscribe 'directory'
Meteor.subscribe 'friends'
Meteor.subscribe 'pins'

handles = []

@setAwayTimeout = ->
  Session.set 'away', false
  _.each handles, (handle) ->
    Meteor.clearTimeout handle
    handles.splice(_.indexOf(handle), 1)

  handles.push(
    Meteor.setTimeout ->
      Session.set 'away', true
    , 300000) # 5 minutes

@signedIn = ->
  if not Meteor.user()
    alert "Please sign-in first"
    return false
  return true