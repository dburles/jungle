Template.userList.helpers {
	users: ->
		Meteor.presences.find { 'state.postId': Session.get 'postId' }, sort: { 'state.username': 1 }
	isUser: ->
		Meteor.userId() is this.userId
}
Template.post.helpers {
	post: ->
		Jungle.findOne Session.get 'postId'
}
Template.messages.helpers {
	messages: ->
		Jungle.find { _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }, sort: { ts: -1 }
	
	count: ->
		Jungle.find({ _id: { $not: Session.get 'postId' }, parentId: Session.get 'postId' }, sort: { ts: -1 }).count()
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