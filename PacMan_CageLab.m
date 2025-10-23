function PacMan_CageLab(opts)
% PACMAN_CAGELAB - Run the PacMan Cage Lab experiment, 
% opts are the settings from the GUI

	fprintf("===>>> PacMan Task Starting...\n");

	% legacy code uses globals :-( TODO - refactor away globals!
	global mapname SubjectName Left

	%% =========================== initial config for PTB
	PsychDefaultSetup(2);

	%% =========================== ALF file paths
	% we use alyxManager to identify the proper save path
	% ALF file paths compatible with Alyx database
	% https://int-brain-lab.github.io/ONE/alf_intro.html
	if isfield(opts,'alyx') && isa(opts.alyx,'alyxManager'); opts.alyx.checkPaths; end
	if isfield(opts,'savePath')
		opts.alyx.paths.savedData = opt.savePath;
	else
		opts.savePath = opts.alyx.paths.savedData;
	end
	opts.alyx.checkPaths; % ensure paths are correct on the local machine
	[opts.alyxPath, opts.sessionID, opts.dateID, opts.ALFName] = opts.alyx.getALF(...
		opts.session.subjectName, opts.session.labName, true);
	opts.dataName = [opts.alyxPath filesep 'matlab.raw.pacman.' opts.ALFName '.mat'];
	
	%% =========================== Set up other paths
	% additional paths, diary is saved to ALF path too
	opts.rootPath = fileparts(mfilename("fullpath"));
	opts.mapPath = [opts.rootPath filesep 'Maps'];
	addpath(opts.mapPath);
	opts.diaryPath = [opts.alyxPath filesep '_matlab_diary.pacman.' opts.ALFName '.log'];
	diary(opts.diaryPath);
	fprintf("\n===>>> PacMan Task ALF path: %s\n",opts.alyxPath);

	%% =========================== hardware initialisation
	if opts.audio
		%we use audio manager as it stops conflicts with PTB tasks.
		opts.aM = audioManager('device', opts.audioDevice,...
		'fileName',fullfile(opts.rootPath, 'explode.mp3'));
		setup(opts.aM);
		opts.aM.beep(2000,0.1,0.1);
	else
		opts.aM = audioManager('silentMode', true);
	end
	if opts.reward
		opts.water = PTBSimia.pumpManager(false); % false = real pump
	else
		opts.water = PTBSimia.pumpManager(true); % true = dummy pump
	end
	opts.broadcast = matmoteGO.broadcast;
	[~,hname] = system('hostname');
	hname = strip(hname);
	if isempty(hname); hname = 'unknown'; end
	opts.hostname = hname;

	%% =========================== keyboard setup
	KbReleaseWait; %make sure keyboard keys are all released
	Priority(0);
	ListenChar(0); %ListenChar(-1); %2=capture all keystrokes
	RestrictKeysForKbCheck([]);
	KbName('UnifyKeyNames');

	%% =========================== other initialisations
	SubjectName = opts.session.subjectName; % comes from CageLab GUI
	Left = 0;
	if ~isfield(opts,'mapName') || isempty(opts.mapName)
		opts.mapName = "GenerateRandomMap_1_oneWay_random";
	end
	[~,opts.mapName,~] = fileparts(opts.mapName); % remove .m
	mapname = opts.mapName;
	
	%% =========================== the current main function
	try
		main_2025(opts);
	catch ME
		sca;
		rethrow(ME)
	end
end


