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
