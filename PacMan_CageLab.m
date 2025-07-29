function PacMan_CageLab(opts)

	% legacy code uses globals
	global pacmanOpts mapname datapath SubjectName Left
	
	% we use alyxManager to identify the save path
	if isfield(opts,'savePath')
		savePath = opt.savePath;
		opts.alyx.paths.savedData = savePath;
	else
		savePath = opts.alyx.paths.savedData;
	end
	[datapath,sID,dID,ALFName] = opts.alyx.getALF(...
		opts.session.subjectName,opts.session.labName,...
		true);
	if isempty(datapath) || ~exist(datapath,'dir')
		mkdir(datapath);
	end

	%% Set up paths
	opts.rootPath = fileparts(mfilename("fullpath"));
	opts.mapPath = [opts.rootPath filesep 'Maps'];
	addpath(opts.mapPath);
	opts.diaryPath = [datapath filesep ['diary.text.' ALFName '.log']];
	diary(opts.diaryPath);

	%% other initialisation
	audioread('explode.mp3');
	SubjectName = opts.session.subjectName;
	Left = 0;
	if isfield(opts,'mapName') && ~isempty(opts.mapName)
		mapname = opts.mapName;
	else
		mapname = "GenerateRandomMap_1_T_random_dir";
	end
	pacmanOpts = opts;
	
	%% the current main function
	try
		main_20181216xy;
	catch ME
		rmdir(datapath);
		sca;
		rethrow(ME)
	end
end


