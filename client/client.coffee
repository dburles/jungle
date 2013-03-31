Session.setDefault 'id', null
Session.setDefault 'username', null
Session.setDefault 'file', null

Meteor.startup ->
	filepicker.setKey "Ay0CJr5oZQi6jI6mzQTbgz"

Meteor.autorun ->
	Meteor.subscribe "jungle"

$action = {
	attachment: {
		show: ->
			$('#attachment #picker').show()
			$('#attachment .ready').hide()
		hide: ->
			$('#attachment #picker').hide()
			$('#attachment .ready').show()
	}
}

Template.top.parent = ->
	Jungle.findOne { _id : Session.get('id') }

Template.messages.messages = ->
	Jungle.find { _id : { $not: Session.get('id') }, parent_id: Session.get('id') }, sort: { ts: -1 }

Template.messages.count = ->
	Jungle.find({ _id : { $not: Session.get('id') }, parent_id: Session.get('id') }, sort: { ts: -1 }).count()

Template.form.events {
	'keyup input#message': (e) ->
		if e.which is 13
			message = $('input#message')

			if Meteor.user()
				name = Meteor.user().username
			else
				name = "Anonymous"
		
			if message.val()
				Jungle.insert {
					parent_id: Session.get('id'),
					user_id: Meteor.userId(),
					name: name, # reference user_id instead, requires more lookups though, remove anonymous
					message: message.val(),
					message_count: 0,
					ts: (new Date).getTime(), # move server side! http://stackoverflow.com/questions/10465673/how-to-use-timestamps-and-preserve-insertion-order-in-meteor
					file: Session.get('file'),
				}
				Jungle.update { _id: Session.get('id') }, { $inc: { message_count: 1 } }
				
				Session.set 'file', null
				message.val("")
				$action.attachment.show()

	'click #attachment #picker': ->
		filepicker.pick {}, 
			(FPFile) ->
				Session.set 'file', FPFile
				$action.attachment.hide()
			(FPError) ->
				
	'click #attachment span.ready a.remove': ->
		filepicker.remove(@file)
		$action.attachment.show()
		false
}

Meteor.Router.add {
	'': -> 
		Session.set 'id', null
		"home"
	'/post/:id': (id) ->
		Session.set 'id', id
		"post"
}

Accounts.ui.config {
	passwordSignupFields: 'USERNAME_AND_EMAIL'
}

