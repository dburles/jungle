
#Meteor.autorun ->

#Meteor.subscribe 'jungle', -> 
#	if Session.get('id')
#		messages = { parent_id: Session.get('id') }

Jungle = new Meteor.Collection "jungle"

if Meteor.isClient
	Meteor.startup ->
		filepicker.setKey("Ay0CJr5oZQi6jI6mzQTbgz")

	Meteor.autorun ->
		Meteor.subscribe "jungle", Session.get('id')

	Template.top.parent = ->
		Jungle.findOne { _id : Session.get('id') }

	Template.messages.posts = ->
		Jungle.find { _id : { $not: Session.get('id') } }, sort: { ts: -1 }
	Template.messages.count = ->
		Jungle.find({ _id : { $not: Session.get('id') } }, sort: { ts: -1 }).count()

	#Template.top.events {
	#	'click a#gotoparent' : ->
	#		Session.set 'id', $('a#gotoparent').attr('href')
	#		$('input#message').focus()
	#}
	
	#Template.messages.events {
	#	'click a': -> $('input#message').focus()
	#}

	Template.form.events {
		'keyup input#message': (e) ->
			if e.which is 13
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
						url: $url.val(),
						name: name,
						message: $message.val(),
						message_count: 0,
						ts: Date.parse(new Date),
						file: @file,
					}
					Jungle.update { _id: Session.get('id') }, { $inc: { message_count: 1 } }
					@file = null

					$url.val("")
					$message.val("")
					$('#attachment #picker').show()
					$('#attachment .ready').hide()

				#$('#messages_wrapper').scrollTop(999999)

		'click #attachment #picker': ->
			filepicker.pick {}, 
				(FPFile) ->
					@file = FPFile 
					#console.log(@file)
					$('#form #attachment #picker').hide()
					$('#attachment .ready').show()
				(FPError) ->
		'click #attachment span.ready a.remove': ->
			#delete file
			filepicker.remove(@file)
			$('#attachment #picker').show()
			$('#attachment .ready').hide()
			false

		#'change #attachment': (e) ->
		#	@file = e.fpfile
	}

	Meteor.Router.add {
		'': -> Session.set('id', null)
		'/post/:id': (id) ->
			#message = Jungle.findOne { _id : id }
			Session.set 'id', id #if message
	}

	Accounts.ui.config {
		passwordSignupFields: 'USERNAME_AND_EMAIL'
	}

if Meteor.isServer
	Meteor.publish "jungle", (parent_id) ->
		Jungle.find { $or: [{ parent_id: parent_id }, { _id: parent_id }] }

	Meteor.startup ->
		if Jungle.find().count() == 0
			user_id = Accounts.createUser {
				username: "dave",
				email: "dburles@gmail.com",
				password: "password",
			}

			Jungle.insert {
				user_id: user_id,
				name: "dave",
				message: "Hello World!",
				message_count: 0,
				ts: Date.parse(new Date),
			}

