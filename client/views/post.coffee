Template.userList.helpers {
	users: ->
		Meteor.presences.find { 'state.id': Session.get 'id' }, sort: { 'state.username': 1 }
}
Template.post.helpers {
	post: ->
		Jungle.findOne Session.get 'id'
}
Template.messages.helpers {
	messages: ->
		Jungle.find { _id: { $not: Session.get 'id' }, parentId: Session.get 'id' }, sort: { ts: -1 }
	
	count: ->
		Jungle.find({ _id: { $not: Session.get 'id' }, parentId: Session.get 'id' }, sort: { ts: -1 }).count()
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
				parentId: Session.get 'id'
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