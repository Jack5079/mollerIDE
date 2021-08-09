let projects\{
	uuid: string,
	repo: string
}[] = JSON.parse(localStorage.getItem 'projects' or '[]')

const del = indexedDB.deleteDatabase.bind(window.indexedDB)
const set = localStorage.setItem.bind(localStorage)

def uuid
	crypto.getRandomValues(new Uint32Array(5))[0].toString(36)

tag moller-ide
	prop project

	css
		.project d:block p:2 ta:left mr:0 bg:gray8 mb:2 cursor:pointer bxs:md
		.action mr:2
		form
			d:flex
			input[type="url"]
				flg:1
		div
			max-width:800px
			m:auto
			d:block
	
	<self>
		if project
				<editor project=project>
		else
			<div>
				<h1> "Welcome to mollerIDE."
				<form @submit.prevent=(do
					const id = uuid!
					projects = [
						...projects,
						repo: $name.value
						uuid: id
					]
					set 'projects', JSON.stringify(projects)
					project = {
						repo: $name.value,
						uuid: id
					}
				)>
					<input$name type="url" required placeholder="A git repo">
					<input type="submit" value="Clone repo">
				for project in projects
					<article.project @click.self=project=project>
						<button.action @click.log('removed', project)=(do
							projects = projects.filter do(p) p.uuid isnt project.uuid
							set 'projects', JSON.stringify(projects)
							del project.uuid
							del "{project.uuid}_lock"
						)> "Delete"
						project.repo
