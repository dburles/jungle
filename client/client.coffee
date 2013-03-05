Jungle = new Meteor.Collection "jungle"

Session.setDefault('id', null)
Session.setDefault('username', null)

Meteor.startup ->
	filepicker.setKey "Ay0CJr5oZQi6jI6mzQTbgz"

Meteor.autorun ->
	Meteor.subscribe "jungle"#, Session.get('id')

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

#Template.home.top = ->

Template.profile.user = ->
	Meteor.users.findOne { username: Session.get('username') }

# # Y U NO WORK??
# Template.profile.messages = ->
# 	user = Meteor.users.findOne { username: Session.get('username') }
# 	if user
# 		Jungle.find { user_id: user._id }

# Template.profile.count = ->
# 	user = Meteor.users.findOne { username: Session.get('username') }
# 	if user
# 		Jungle.find({ user_id: user._id }).count()

Template.messages.messages = ->
	Jungle.find { _id : { $not: Session.get('id') }, parent_id: Session.get('id') }, sort: { ts: -1 }

Template.messages.count = ->
	Jungle.find({ _id : { $not: Session.get('id') }, parent_id: Session.get('id') }, sort: { ts: -1 }).count()

Template.top.parent = ->
	Jungle.findOne { _id : Session.get('id') }

Template.messages.events {
	'mouseenter .stuff': (e) ->
		console.log(e)
		$(e.target).parent().css('background', '#DDD')
	'mouseleave .stuff': (e) ->
		$(e.target).parent().css('background', '#FFF')
	'click .stuff': (e) ->
		$(e.target).parent().find('td.message').css('background', 'pink')
		$(e.target).parent().find('td.message').html('<a href="#">view profile</a>, <a href="#">save message to profile</a>, <a href="#">private message</a>, <a href="#">add to friends</a>')


}

Template.form.events {
	'keyup input#message': (e) ->
		if e.which is 13
			@file = null
			$url = $('input#url')
			$message = $('input#message')

			if Meteor.user()
				name = Meteor.user().username
			else
				name = "Anonymous"
		
			if $message.val()
				Jungle.insert {
					parent_id: Session.get('id'),
					user_id: Meteor.userId(),
					name: name,
					message: $message.val(),
					message_count: 0,
					ts: (new Date).getTime(), # move server side! http://stackoverflow.com/questions/10465673/how-to-use-timestamps-and-preserve-insertion-order-in-meteor
					file: @file,
				}
				Jungle.update { _id: Session.get('id') }, { $inc: { message_count: 1 } }

				$url.val("")
				$message.val("")
				$action.attachment.show()

	'click #attachment #picker': ->
		filepicker.pick {}, 
			(FPFile) ->
				@file = FPFile 
				#console.log(@file)
				$action.attachment.hide()
			(FPError) ->
				
	'click #attachment span.ready a.remove': ->
		#delete file
		filepicker.remove(@file)
		$action.attachment.show()
		false
}

Meteor.Router.add {
	'': -> 
		#Session.set('id', null)
		"home"
	'/post/:id': (id) ->
		Session.set('id', id)
		"post"
	'/profile/:username': (username) ->
		Session.set('username', username)
		"profile"
}

Accounts.ui.config {
	passwordSignupFields: 'USERNAME_AND_EMAIL'
}

