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
	prop msgs\string[] = []

	css code
		d:block

	css nav
		bg:gray9
		overflow:auto
		h:100%
		pos:fixed
		top:0
		left:0
		width:30%
		padding-left: 1em
	
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
				onMessage: def pain msg
					msgs = [...msgs,msg]
					imba.commit!
			}).then(do
				files = await fs.promises.readdir('/')
				imba.commit!
			)
		
		imba.commit!

	def render
		<self>
			if files.length
				<nav>
					<folder fs=fs>
			else
				<h1> "Cloning repo..."
				for msg in msgs
					<code> msg
