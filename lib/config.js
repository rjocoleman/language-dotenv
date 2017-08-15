'use babel';

const Settings = {
	dotenvFileNames: {
		title: 'Filenames',
		description: 'Filenames to associate with the Dotenv grammar. Ex. .env, .env.local',
		type: 'array',
		default: ['.env'],
		order: 1
	}
};

export {Settings};