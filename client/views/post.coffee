Template.userList.helpers {
	users: ->
		presences = Meteor.presences.find { 'state.postId': Session.get 'postId' }, sort: { 'state.username': 1 }
		Meteor.users.find { _id: { $in: presences.map (p) -> p.userId }}

	anonymousCount: ->
		Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count()

	hasAnonymousUsers: ->
		Meteor.presences.find({ 'state.postId': Session.get('postId'), userId: { $exists: false }}).count() > 0

	isUser: ->
		Meteor.userId() is @._id
}

Template.post.helpers {
	post: ->
		Jungle.findOne Session.get 'postId'
}

Template.messages.helpers {
	messages: ->
		Jungle.find { _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }, sort: { ts: -1 }
	
	count: ->
		Jungle.find({ _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }).count()
}

Template.messageForm.helpers {
	fileReady: ->
		Session.get 'file'
}

Template.messageForm.events {
	'submit form': (event, template) ->
		event.preventDefault()
		message = template.find 'input[name=message]'

		if message.value
			Meteor.call 'addMessage', {
				_id: Random.id() # fix for client/server id bug
				parentId: Session.get 'postId'
				message: message.value
				file: Session.get 'file'
			}
			Session.set 'file', null
			event.target.reset()

	'click a#picker': ->
		filepicker.pick {},
			(FPFile) ->
				Session.set 'file', FPFile
			(FPError) ->
				
	'click a#removeFile': ->
		filepicker.remove Session.get 'file'
		Session.set 'file', null
		false
}