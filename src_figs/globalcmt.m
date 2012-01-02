function varargout = globalcmt(varargin)
% Helper window to download focal mechanisms data from www.globalcmt.org

%	Copyright (c) 2004-2012 by J. Luis
%
% 	This program is part of Mirone and is free software; you can redistribute
% 	it and/or modify it under the terms of the GNU Lesser General Public
% 	License as published by the Free Software Foundation; either
% 	version 2.1 of the License, or any later version.
% 
% 	This program is distributed in the hope that it will be useful,
% 	but WITHOUT ANY WARRANTY; without even the implied warranty of
% 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% 	Lesser General Public License for more details.
%
%	Contact info: w3.ualg.pt/~jluis/mirone
% --------------------------------------------------------------------

	if (isempty(varargin))
		errordlg('GlobalCMT: wrong number of input arguments.','Error'),	return
	end
	
	handles.hMirFig = varargin{1};
	handMir = guidata(handles.hMirFig);

	if (~handMir.no_file && ~handMir.geog)
		errordlg('GlobalCMT: To use this tool your map needs to in geographical coordinates','Error'),	return
	end

	hObject = figure('Vis','off');
	globalcmt_LayoutFcn(hObject);
	handles = guihandles(hObject);
	move2side(hObject,'center');

	handles.hMirFig = varargin{1};

	if (numel(varargin) == 1)
		handles.x_min = [];		handles.x_max = [];
		handles.y_min = [];		handles.y_max = [];
	else									% ROI rectangle was sent in
		if (ishandle(varargin{2}))			% Not tested further but it must be a line rectangle handle
			x = get(varargin{2}, 'XData');		y = get(varargin{2}, 'YData');
			handles.x_min = double(min(x));		handles.x_max = double(max(x));
			handles.y_min = double(min(y));		handles.y_max = double(max(y));
		else
			handles.x_min = varargin{2}(1);		handles.x_max = varargin{2}(2);
			handles.y_min = varargin{2}(3);		handles.y_max = varargin{2}(4);
		end
		set(handles.edit_West, 'Str', sprintf('%8g', handles.x_min), 'Enable', 'off') 
		set(handles.edit_East, 'Str', sprintf('%8g', handles.x_max), 'Enable', 'off') 
		set(handles.edit_South,'Str', sprintf('%8g', handles.y_min), 'Enable', 'off') 
		set(handles.edit_North,'Str', sprintf('%8g', handles.y_max), 'Enable', 'off') 
	end

	time = clock;
	set(handles.edit_EndYear,'String',sprintf('%d',time(1)))
	set(handles.edit_EndMonth,'String',sprintf('%d',time(2)))
	set(handles.edit_EndDay,'String',sprintf('%d',time(3)))

	% Add this figure handle to the carra?as list
	plugedWin = getappdata(handles.hMirFig,'dependentFigs');
	plugedWin = [plugedWin hObject];
	setappdata(handles.hMirFig,'dependentFigs',plugedWin);

	guidata(hObject, handles);

	set(hObject,'Visible','on');
	if (nargout),   varargout{1} = hObject;     end
	if (handMir.scale2meanLat)
		warndlg(['You have the "Scale geog images at mean lat" active in preferences.' ...
		'Unfortunately this will deform the beach-balls. You better unset it.'],'Warning')
	end

% -------------------------------------------------------------------------------------
function edit_StartYear_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1976),    set(hObject,'String','1976');   end

% -------------------------------------------------------------------------------------
function edit_StartMonth_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1 || xx > 12),	set(hObject,'String','1'),	end

% -------------------------------------------------------------------------------------
function edit_StartDay_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1 || xx > 31),	set(hObject,'String','1'),	end

% -------------------------------------------------------------------------------------
function edit_EndYear_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1976),    set(hObject,'String','');   end

% -------------------------------------------------------------------------------------
function edit_EndMonth_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1 || xx > 12),	set(hObject,'String','1'),	end

% -------------------------------------------------------------------------------------
function edit_EndDay_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 1 || xx > 31),	set(hObject,'String','1'),	end

% -------------------------------------------------------------------------------------
function edit_MagMwMin_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','0'),	end

% -------------------------------------------------------------------------------------
function edit_MagMwMax_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','10'),	end

% -------------------------------------------------------------------------------------
function edit_MagMsMin_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','0'),	end

% -------------------------------------------------------------------------------------
function edit_MagMsMax_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','10'),	end

% -------------------------------------------------------------------------------------
function edit_MagMbMin_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','0'),	end

% -------------------------------------------------------------------------------------
function edit_MagMbMax_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 10),	set(hObject,'String','10'),	end

% -------------------------------------------------------------------------------------
function edit_DepthMin_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0),	set(hObject,'String','0'),	end

% -------------------------------------------------------------------------------------
function edit_DepthMax_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx) || xx < 0 || xx > 1000),    set(hObject,'String','1000');       end

% -------------------------------------------------------------------------------------
function edit_West_CB(hObject, handles)
	xx = get(hObject,'String');     val = test_dms(xx);
	if ~isempty(val)				% when dd:mm or dd:mm:ss was given
		x_min = 0;
		if str2double(val{1}) > 0
			for i = 1:length(val),  x_min = x_min + str2double(val{i}) / (60^(i-1));    end
		else
			for i = 1:length(val),  x_min = x_min - abs(str2double(val{i})) / (60^(i-1));   end
		end
		handles.x_min = x_min;
		if (~isempty(handles.x_max) && x_min >= handles.x_max)
			errordlg('West Longitude >= East Longitude ','Error in Longitude limits')
			handles.x_min = [];
			set(hObject,'String',''),	guidata(hObject, handles),	return
		end
	else				% box is empty
		set(hObject,'String','');		handles.x_min = [];
	end
	guidata(hObject, handles);

% -------------------------------------------------------------------------------------
function edit_East_CB(hObject, handles)
	xx = get(hObject,'String');     val = test_dms(xx);
	if ~isempty(val)				% when dd:mm or dd:mm:ss was given
		x_max = 0;
		if str2double(val{1}) > 0
			for i = 1:length(val),  x_max = x_max + str2double(val{i}) / (60^(i-1));    end
		else
			for i = 1:length(val),  x_max = x_max - abs(str2double(val{i})) / (60^(i-1));   end
		end
		handles.x_max = x_max;
		if (~isempty(handles.x_min) && x_max <= handles.x_min)
			errordlg('East Longitude <= West Longitude','Error in Longitude limits')
			handles.x_max = [];
			set(hObject,'String',''),	guidata(hObject, handles),	return
		end
	else				% box is empty
		set(hObject,'String','');		handles.x_max = [];
	end
	guidata(hObject, handles);

% -------------------------------------------------------------------------------------
function edit_South_CB(hObject, handles)
	xx = get(hObject,'String');     val = test_dms(xx);
	if ~isempty(val)				% when dd:mm or dd:mm:ss was given
		y_min = 0;
		if str2double(val{1}) > 0
			for i = 1:length(val),  y_min = y_min + str2double(val{i}) / (60^(i-1));    end
		else
			for i = 1:length(val),  y_min = y_min - abs(str2double(val{i})) / (60^(i-1));   end
		end
		handles.y_min = y_min;
		if ~isempty(handles.y_max) && y_min >= handles.y_max
			errordlg('South Latitude >= North Latitude','Error in Latitude limits')
			handles.y_min = [];
			set(hObject,'String','');   guidata(hObject, handles);  return
		end
	else				% box is empty
		set(hObject,'String','');		handles.y_min = [];
	end
	guidata(hObject, handles);

% -------------------------------------------------------------------------------------
function edit_North_CB(hObject, handles)
	xx = get(hObject,'String');     val = test_dms(xx);
	if ~isempty(val)				% when dd:mm or dd:mm:ss was given
		y_max = 0;
		if str2double(val{1}) > 0
			for i = 1:length(val),   y_max = y_max + str2double(val{i}) / (60^(i-1));    end
		else
			for i = 1:length(val),   y_max = y_max - abs(str2double(val{i})) / (60^(i-1));   end
		end
		handles.y_max = y_max;
		if ~isempty(handles.y_min) && y_max <= handles.y_min
			errordlg('North Latitude <= South Latitude','Error in Latitude limits')
			handles.y_max = [];
			set(hObject,'String',''),	guidata(hObject, handles),	return
		end
	else				% box is empty
		set(hObject,'String',''),		handles.y_max = [];
	end
	guidata(hObject, handles);

% -------------------------------------------------------------------------------------
function push_OK_CB(hObject, handles)
% ...
	if ( any( isempty([handles.x_min handles.x_max handles.y_min handles.y_max]) ) )
		errordlg('Interest region is not fully specified.','Error'),	return
	end
	% Other qantities are tested by the callbacks, so we should be done here.

	url = ['http://www.globalcmt.org/cgi-bin/globalcmt-cgi-bin/CMT4/form?itype=ymd&yr=' ...
		get(handles.edit_StartYear,'Str'), ...
		'&mo=' get(handles.edit_StartMonth,'Str'), ...
		'&day=' get(handles.edit_StartDay,'Str'), ...
		'&otype=ymd&oyr=' get(handles.edit_EndYear,'Str'), ...
		'&omo=' get(handles.edit_EndMonth,'Str'), ...
		'&oday=' get(handles.edit_EndDay,'Str'), ...
		'&jyr=2000&jday=1&ojyr=2010&ojday=1&nday=1', ...	% Not used, I think
		'&lmw=' get(handles.edit_MagMwMin,'Str'), ...
		'&umw=' get(handles.edit_MagMwMax,'Str'), ...
		'&lms=' get(handles.edit_MagMsMin,'Str'), ...
		'&ums=' get(handles.edit_MagMsMax,'Str'), ...
		'&lmb=' get(handles.edit_MagMbMin,'Str'), ...
		'&umb=' get(handles.edit_MagMbMax,'Str'), ...
		'&llat=' sprintf('%.8g', handles.y_min), ...
		'&ulat=' sprintf('%.8g', handles.y_max), ...
		'&llon=' sprintf('%.8g', handles.x_min), ...
		'&ulon=' sprintf('%.8g', handles.x_max), ...
		'&lhd=' get(handles.edit_DepthMin,'Str'), ...
		'&uhd=' get(handles.edit_DepthMax,'Str'), ...
		'&lts=-9999&uts=9999&lpe1=0&upe1=90&lpe2=0&upe2=90&list=3'];

	% Sadly does not provide data in a simple format that we can use. Old psvelomeca comes very close
	% but it lacks the depth, so we are obliged to download two format versions of the same data and
	% fish what we need from both of them.
	set(handles.figure1,'pointer','watch')
	dest_fiche = 'lixogrr.html';
	for (n = 1:2)
		if (n == 2),	url(end) = '2';		end			% Get data with the A&R convention 
		if (ispc),		dos(['wget "' url '" -q --tries=2 --connect-timeout=5 -O ' dest_fiche]);
		else			unix(['wget ''' url ''' -q --tries=2 --connect-timeout=5 -O ' dest_fiche]);
		end

		finfo = dir(dest_fiche);
		if (finfo.bytes < 100)					% Delete the file anyway because it exists but is empty
			warndlg('Failed to download the CMT file.','Warning')
			builtin('delete',dest_fiche);
			set(handles.figure1,'pointer','arrow'),		return
		end

		fid = fopen(dest_fiche,'r');
		for (k = 1:24)					% Jump first 24 html related lines
			lix = fgets(fid);
		end
		todos = fread(fid,'*char');		fclose(fid);
		if (todos(1) == '<')
			warndlg('Could not find any event with this parameters search.','Warning')
			builtin('delete',dest_fiche);
			set(handles.figure1,'pointer','arrow'),		return
		end

		eols = find(todos == char(10));				% Find the new line breaks
		todos(eols(numel(eols)-9):end) = [];		% Remove last 9 lines that have no data

		if (n == 1)
			[lix lat lon depth lix lix mag lix lix lix lix lix lix lix] = ...
				strread(todos,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f');
		else
			[lix lix strike dip rake lix lix lix lix lix data] = ...
				strread(todos,'%f %f %f %f %f %f %f %f %f %f %s');
		end
	end

	set(handles.figure1,'pointer','arrow')
	builtin('delete',dest_fiche);

	focal_meca(handles.hMirFig,[lon lat depth strike dip rake mag], data, ...
		[handles.x_min handles.x_max handles.y_min handles.y_max])

% -----------------------------------------------------------------------------
function figure1_KeyPressFcn(hObject, eventdata)
	if isequal(get(hObject,'CurrentKey'),'escape')
		handles = guidata(hObject);
        delete(handles.figure1);
	end

% --- Creates and returns a handle to the GUI figure. 
function globalcmt_LayoutFcn(h1)

set(h1,...
'Color',get(0,'factoryUicontrolBackgroundColor'),...
'KeyPressFcn',@figure1_KeyPressFcn,...
'MenuBar','none',...
'Name','GlobalCMT',...
'NumberTitle','off',...
'Position',[520 491 331 309],...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[50 275 47 21],...
'String','1976',...
'Style','edit',...
'Tag','edit_StartYear');

uicontrol('Parent',h1, 'Position',[10 265 36 33],...
'String',{'Start'; 'year' },...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[164 275 47 21],...
'String','1',...
'Style','edit',...
'Tag','edit_StartMonth');

uicontrol('Parent',h1, 'Position',[120 269 41 30],...
'String',{'Start'; 'month'},...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[274 275 47 21],...
'String','1',...
'Style','edit',...
'Tag','edit_StartDay');

uicontrol('Parent',h1, 'Position',[237 269 36 30],...
'String',{'Start'; 'day' },...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[50 238 47 21],...
'String','',...
'Style','edit',...
'Tag','edit_EndYear');

uicontrol('Parent',h1, 'Position',[10 234 36 30],...
'String',{'End'; 'year'},...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[164 238 47 21],...
'String','',...
'Style','edit',...
'Tag','edit_EndMonth');

uicontrol('Parent',h1, 'Position',[120 234 41 30],...
'String',{'End'; 'month'},...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[274 238 47 21],...
'String','',...
'Style','edit',...
'Tag','edit_EndDay');

uicontrol('Parent',h1, 'Position',[243 234 27 30],...
'String',{'End'; 'day'},...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[150 188 47 21],...
'String','0',...
'Style','edit',...
'Tag','edit_MagMwMin');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[274 188 47 21],...
'String','10',...
'Style','edit',...
'Tag','edit_MagMwMax');

uicontrol('Parent',h1,...
'HorizontalAlignment','left',...
'Position',[10 192 110 15],...
'String','Moment magnitude',...
'Style','text');

uicontrol('Parent',h1,...
'Position',[205 191 61 16],...
'String','<= Mw <=',...
'Style','text');

uicontrol('Parent',h1, 'Position',[10 9 42 30],...
'String',{'Minimum'; 'depth'},...
'Style','text');

uicontrol('Parent',h1, 'Position',[126 8 51 30],...
'String',{'Maximum'; 'depth'},...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[54 14 47 21],...
'String','0',...
'Style','edit',...
'Tooltip','Depth in km',...
'Tag','edit_DepthMin');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[178 14 47 21],...
'String','1000',...
'Style','edit',...
'Tooltip','Depth in km',...
'Tag','edit_DepthMax');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[150 158 47 21],...
'String','0',...
'Style','edit',...
'Tag','edit_MagMsMin');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[274 158 47 21],...
'String','10',...
'Style','edit',...
'Tag','edit_MagMsMax');

uicontrol('Parent',h1,...
'HorizontalAlignment','left',...
'Position',[10 161 140 15],...
'String','Surface wave magnitude',...
'Style','text');

uicontrol('Parent',h1, 'Position',[205 161 61 16],...
'String','<= Ms <=',...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[150 128 47 21],...
'String','0',...
'Style','edit',...
'Tag','edit_MagMbMin');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[274 128 47 21],...
'String','10',...
'Style','edit',...
'Tag','edit_MagMbMax');

uicontrol('Parent',h1,...
'HorizontalAlignment','left',...
'Position',[10 131 130 15],...
'String','Body wave magnitude',...
'Style','text');

uicontrol('Parent',h1, 'Position',[205 131 61 16],...
'String','<= mb <=',...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[120 88 81 22],...
'String','',...
'Style','edit',...
'Tooltip','West Longitude in the [-180; 180] interval. You may use dd:mm notation',...
'Tag','edit_West');

uicontrol( 'Parent',h1,...
'HorizontalAlignment','left',...
'Position',[10 89 110 16],...
'String','Longitude: (from: W)',...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[240 88 81 22],...
'String','',...
'Style','edit',...
'Tooltip','East Longitude in the [-180; 180] interval. You may use dd:mm notation',...
'Tag','edit_East');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[120 58 81 22],...
'String','',...
'Style','edit',...
'Tooltip','South Latitude. You may use dd:mm notation',...
'Tag','edit_South');

uicontrol('Parent',h1,...
'HorizontalAlignment','left',...
'Position',[10 59 101 16],...
'String','Latitude: (from: S)',...
'Style','text');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Call',@globalcmt_uiCB,...
'Position',[240 58 81 22],...
'String','',...
'Style','edit',...
'Tooltip','North Latitude. You may use dd:mm notation',...
'Tag','edit_North');

uicontrol('Parent',h1, 'Position',[204 61 35 16],...
'String','to: N',...
'Style','text');

uicontrol('Parent',h1, 'Position',[202 90 35 16],...
'String','to: E',...
'Style','text');

uicontrol('Parent',h1,...
'Call',@globalcmt_uiCB,...
'Position',[256 8 66 23],...
'String','OK',...
'Tag','push_OK');


function globalcmt_uiCB(hObject, eventdata)
% This function is executed by the callback and than the handles is allways updated.
	feval([get(hObject,'Tag') '_CB'],hObject, guidata(hObject));
