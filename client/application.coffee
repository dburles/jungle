Accounts.ui.config {
	passwordSignupFields: 'USERNAME_AND_EMAIL'
}

Session.setDefault 'postId', null
Session.setDefault 'username', null
Session.setDefault 'file', null
Session.setDefault 'fileReady', null

Meteor.startup ->
	filepicker.setKey 'Ay0CJr5oZQi6jI6mzQTbgz'

Deps.autorun ->
  Meteor.subscribe 'userPresence', Session.get 'postId'
  Meteor.subscribe 'jungle', Session.get 'postId'
  # if (Meteor.user())
  #   Meteor.subscribe 'friends', Meteor.userId()


Meteor.subscribe 'directory'
Meteor.subscribe 'friends'

# Deps.autorun ->
# 	Meteor.subscribe 'jungle', Session.get 'postId'
# 	if Meteor.user()
# 		Meteor.subscribe 'userPresence', Session.get 'postId', Friends.find({userId: Meteor.userId()})
# 	else
# 		Meteor.subscribe 'userPresence', Session.get 'postId'
	
# 	Meteor.subscribe 'directory'
	
	# if Meteor.user()
	# 	Meteor.subscribe 'friends', Meteor.userId()
	


# logger = TLog.getLogger()
# logger.setOptions TLog.LOGLEVEL_MAX, true, true, true