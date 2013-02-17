Jungle = new Meteor.Collection "jungle"

if Meteor.isClient
	Meteor.startup ->
		filepicker.setKey "Ay0CJr5oZQi6jI6mzQTbgz"

	Meteor.autorun ->
		Meteor.subscribe "jungle", Session.get('id')

	#Template.home.top = ->


	Template.top.parent = ->
		Jungle.findOne { _id : Session.get('id') }

	Template.messages.messages = ->
		Jungle.find { _id : { $not: Session.get('id') } }, sort: { ts: -1 }
	
	Template.messages.count = ->
		Jungle.find({ _id : { $not: Session.get('id') } }, sort: { ts: -1 }).count()

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
						name: name,
						message: $message.val(),
						message_count: 0,
						ts: (new Date).getTime(), # move server side! http://stackoverflow.com/questions/10465673/how-to-use-timestamps-and-preserve-insertion-order-in-meteor
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
		'': -> 
			Session.set('id', null)
			"home"
		'/post/:id': (id) ->
			Session.set('id', id)
			"post"
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

	Jungle.allow {
		insert: ->
			true
		update: ->
			true
		remove: ->
			false
	}
