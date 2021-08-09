import LightningFS from '@isomorphic-git/lightning-fs'
import {resolve} from '@isomorphic-git/lightning-fs/src/path'
import { getIconForFile as file_icon, getIconForFolder as folder_icon } from 'vscode-icons-js'

tag folder
	prop path = '/'
	prop name = ''
	prop fs\LightningFS

	css li
		list-style: none

	css summary, li d:flex a:center
	css img mr:5
	css 
		details
			&:not(.root)
				& > *:not(summary)
					padding-left: 1em
	css .root
		& > summary 
			list-style: none

		& > summary::-webkit-details-marker
			d:none
		
	<self>
		<details.root=(path is '/') open=(path is '/')>
			<summary>
				if path isnt '/'
					<img alt=name width="23" height="23" src="https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/icons/{folder_icon name}">
				name
			
			const files\string[] = await fs.promises.readdir path

			for file in files
				<li>
					const stat = await fs.promises.stat resolve path, file
					if stat.type == 'dir'
						<folder path=resolve(path, file) name=file fs=fs>
					else
						<img alt=file width="23" height="23" src="https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/icons/{file_icon file}">
						file
