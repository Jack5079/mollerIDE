import LightningFS from '@isomorphic-git/lightning-fs'
import {resolve} from '@isomorphic-git/lightning-fs/src/path'
import { getIconForFile as file_icon, getIconForFolder as folder_icon } from 'vscode-icons-js'

tag folder
	prop path = '/'
	prop name = ''
	prop fs\LightningFS

	css 
		.item tween:background .3s cursor:pointer bg:none @hover:gray8 @focus:gray7
		li w:100% list-style: none us:none
		img mr:5
		details
			&:not(.root)
				& > *:not(summary)
					pl:1em
		summary 
			list-style: none
			&::-webkit-details-marker
				d:none

	<self>
		<details.root=(path is '/') open=(path is '/')>
			<summary.item>
				if path isnt '/'
					<img alt=name width="23" height="23" src="https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/icons/{folder_icon name}">
				name
			
			const files\string[] = await fs.promises.readdir path

			for file in files
				const stat = await fs.promises.stat resolve path, file
				<li.item=(stat.type is 'file')>
					if stat.type is 'dir'
						<folder path=resolve(path, file) name=file fs=fs>
					else
						<img alt=file width="23" height="23" src="https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/icons/{file_icon file}">
						file
