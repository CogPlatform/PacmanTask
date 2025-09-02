function PacMan_CageLab(opts)
% PACMAN_CAGELAB - Run the PacMan Cage Lab experiment, 
% opts are the settings from the GUI

	fprintf("===>>> PacMan Task Starting...\n");

	% legacy code uses globals :-( TODO - refactor away globals!
	global mapname datapath SubjectName Left

	% initial config for PTB
	PsychDefaultSetup(2);
	
	% we use alyxManager to identify the proper save path
	% ALF file paths compatible with Alyx database
	% https://int-brain-lab.github.io/ONE/alf_intro.html
	if isfield(opts,'savePath')
		opts.alyx.paths.savedData = opt.savePath;
	else
		opts.savePath = opts.alyx.paths.savedData;
	end
	opts.alyx.checkPaths; % ensure paths are correct on the local machine
	[opts.dataPath, opts.sID, opts.dID, opts.ALFName] = opts.alyx.getALF(...
		opts.session.subjectName, opts.session.labName, true);
	datapath = opts.dataPath;
	opts.dataName = [opts.dataPath filesep 'matlab.raw.' opts.ALFName '.mat'];

	%% Set up paths
	opts.rootPath = fileparts(mfilename("fullpath"));
	opts.mapPath = [opts.rootPath filesep 'Maps'];
	addpath(opts.mapPath);
	opts.diaryPath = [opts.dataPath filesep '_matlab_diary.' opts.ALFName '.log'];
	diary(opts.diaryPath);
	fprintf("===>>> PacMan Task ALF path: %s\n",opts.dataPath);

	%% other initialisation
	if opts.audio
		%we use audio manager as it stops conflicts with PTB tasks.
		opts.aM = audioManager('fileNath',fullfile(opts.rootPath, 'explode.mp3'));
		setup(opts.aM);
	else
		opts.aM = audioManager('silentMode', true);
	end
	if opts.reward
		opts.water = PTBSimia.pumpManager(false); % false = real pump
	else
		opts.water = PTBSimia.pumpManager(true); % true = dummy pump
	end

	SubjectName = opts.session.subjectName;
	Left = 0;
	if ~isfield(opts,'mapName') || isempty(opts.mapName)
		opts.mapName = "GenerateRandomMap_1_oneWay_random";
	end
	[~,opts.mapName,~] = fileparts(opts.mapName);
	mapname = opts.mapName;
	
	%% the current main function
	try
		main_2025(opts);
	catch ME
		sca;
		rethrow(ME)
	end
end


