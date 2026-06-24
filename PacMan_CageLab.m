function PacMan_CageLab(opts)
% PACMAN_CAGELAB - Run the PacMan Cage Lab experiment, 
% opts are the settings from the GUI

	opts.version = '2026-06-11'; % for debugging, to track which version is running
	opts.cagelab-version = clutil.version; % for debugging, to track which version of CageLab is running
	
	%% =========================== initial config for PTB and opticka
	addOptickaToPath(); % add opticka to path, for alyx, hardware and broadcasting
	PsychDefaultSetup(2);

	%% ==========================================
	% CageLab uses several class objects to communicate
	% opts.alyx = alyxManager talks to alyx database, configures save filenames
	% opts.status = cogmoteGO status (running or not) update
	% opts.broadcast = cogmoteGO broadcast latest trial data
	% opts.zmq = communicate directly to cogmoteGO, get commands from remote control PC

	%% =========================== ALF file paths
	% we use alyxManager to identify the save path
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
	opts.jsonName = [opts.alyxPath filesep 'opticka.details.pacman.' opts.ALFName '.json'];
	opts.eventsName = [opts.alyxPath filesep 'events.table.' opts.ALFName '.tsv'];
	
	%% =========================== Set up other paths
	% additional paths, diary is saved to ALF path too
	opts.rootPath = fileparts(mfilename("fullpath"));
	addpath([opts.rootPath filesep 'vedioCode/src/rawDrawCode/draw']); % drawing functions
	if ~isfield(opts,'mapPath') || ~exist(opts.mapPath,'dir')
		opts.mapPath = [opts.rootPath filesep 'Maps'];
	end
	opts.diaryPath = [opts.alyxPath filesep '_matlab_diary.pacman.' opts.ALFName '.log'];
	diary(opts.diaryPath);

	fprintf("\n===>>> PacMan %s Task Starting...\n", opts.version);
	disp(opts);
	fprintf("\n===>>> PacMan Task ALF path: %s\n",opts.alyxPath);

	%% =========================== force resolution
	if opts.screen > max(Screen('Screens')); opts.screen = max(Screen('Screens')); end
	if opts.forceResolution
		try Screen('Resolution',opts.screen,1920,1080,60); end
		disp(Screen('Resolution',opts.screen));
	end

	%% =========================== hardware initialisation
	if opts.audio
		%we use audio manager as it stops conflicts with PTB tasks.
		opts.aM = audioManager('device', opts.audioDevice,...
		'lowLatency',true,...
		'fileName',fullfile(opts.rootPath, 'explode.mp3'),...
		'volumeLevel', opts.audioVolume);
		setup(opts.aM);
		loadSamples(opts.aM);
		if opts.audioBeeps; opts.aM.beep(3000,0.1,opts.audioVolume); end
	else
		opts.aM = audioManager('silentMode', true);
	end
	if opts.reward
		opts.water = PTBSimia.pumpManager(false); % false = real pump
		opts.water.giveReward(10); % preload/test the pump code
	else
		opts.water = PTBSimia.pumpManager(true); % true = dummy pump
	end
	opts.broadcast = matmoteGO.broadcast(); % initialize broadcast function to send data to cogmoteGO
	opts.status = matmoteGO.status(); % initialize cogmoteGO status updater
	opts.tL = timeLogger('preallocateTimes',10); % initialize time logger to record timestamped messages\
	preAllocate(opts.tL);
	[~,hname] = system('hostname');
	hname = strip(hname);
	if isempty(hname); hname = 'unknown'; end
	opts.hostname = hname;
	opts.opticka-version = opts.tL.optickaVersion;
	addMessage(opts.tL, 0, [], [], sprintf("PacMan Task Initialized on %s", opts.hostname), "","Experimental-note");
	addMessage(opts.tL, 0, [], [], "CageLab V" + clutil.version, "", "Version-identifier");
	addMessage(opts.tL, 0, [], [], "Opticka V" + opts.tL.optickaVersion, "", "Version-identifier");
	addMessage(opts.tL, 0, [], [], "PacManTask V" + opts.version, "", "Version-identifier");
	addMessage(opts.tL, 0, [], [], string(opts.dataName), "", "Pathname");
	addMessage(opts.tL, 0, [], [], string(opts.diaryPath), "", "Pathname");
	addMessage(opts.tL, 0, [], [], string(opts.eventsName), "", "Pathname");
	addMessage(opts.tL, 0, [], [], string(opts.jsonName), "", "Pathname");
	
	%% =========================== messaging setup
	if ~opts.remote
		% we don't need zmq, set to empty
		opts.zmq = [];
	end

	%% =========================== keyboard setup
	Priority(0);
	ListenChar(0); %ListenChar(-1); %2=capture all keystrokes
	RestrictKeysForKbCheck([]);
	clear PsychHID; % clear any previous keyboard events
	clear KbCheck; % clear any previous keyboard events

	%% =========================== other initialisations
	if ~isfield(opts,'mapName') || isempty(opts.mapName)
		opts.mapName = "GenerateRandomMap_1_oneWay_random";
	end
	[~,opts.mapName,~] = fileparts(opts.mapName); % remove .m
	mapname = opts.mapName;
	
	%% =========================== the current main function
	try
		main_2025(opts);
	catch ME
		getReport(ME)
		try opts.status.updateStatusToStopped(); end
		sca;
		rethrow(ME)
	end
end


