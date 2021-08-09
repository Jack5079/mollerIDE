import LightningFS from '@isomorphic-git/lightning-fs'
import git from 'isomorphic-git'
import http from 'isomorphic-git/http/web/index.js'
import './folder.imba'
tag editor
	prop project\{
		uuid: string,
		repo: string
	}

	prop fs\LightningFS
	prop files\string[] = []

	# Clone repo stuff
	prop msgs\string[] = []
	prop error\string = ''

	# Loading bar
	prop phase\string = 'Getting ready'
	prop progress\number

	css pre
		margin:0
	css nav
		bg:gray9
		overflow:auto
		h:100%
		pos:fixed
		top:0
		left:0
		width:30%
		padding-left: 1em
	
	css textarea
		bg:gray8
		c:white
		resize:none
		overflow:auto
		h:100%
		pos:fixed
		top:0
		left:30%
		border:0
		width:70%

	def awaken
		fs = new LightningFS(project.uuid)
		files = await fs.promises.readdir('/')
		if !files.length
			git.clone({
				http,
				fs,
				dir: '/',
				url: project.repo,
				corsProxy: 'https://cors.isomorphic-git.org',
				onProgress: do(event)
					console.log(event)
					phase = event.phase
					if event.total
						progress = event.loaded / event.total
					else
						progress = undefined
					imba.commit!
				onMessage: do(msg)
					msgs = [...msgs,msg]
					imba.commit!
			}).then(do
				files = await fs.promises.readdir('/')
				imba.commit!
			).catch(do(err)
				error = err
				imba.commit!
			)
		
		imba.commit!

	def render
		<self>
			if error
				<h1> "Error while cloning repo!"
				<pre> String error
			elif files.length
				<nav>
					<folder fs=fs>
				<textarea>
			else
				<h1> "{phase}..."
				if progress isnt undefined
					<progress min=0 max=1 value=progress>
				else
					<progress min=0 max=1>
				for msg in msgs
					<pre> msg
