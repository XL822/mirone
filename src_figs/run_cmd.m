function varargout = run_cmd(varargin)
% Helper Window to run a Matlab command

%	Copyright (c) 2004-2018 by J. Luis
%
%             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
%                     Version 2, December 2004
% 
%  Everyone is permitted to copy and distribute verbatim or modified
%  copies of this license document, and changing it is allowed as long
%  as the name is changed.
% 
%             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
%    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
% 
%   0. You just DO WHAT THE FUCK YOU WANT TO.
%
%	Contact info: w3.ualg.pt/~jluis/mirone
% --------------------------------------------------------------------

% $Id$

	if (nargin > 1 && ischar(varargin{1}))
		gui_CB = str2func(varargin{1});
		[varargout{1:nargout}] = feval(gui_CB,varargin{2:end});
	else
		h = run_cmd_OF(varargin{:});
		if (nargout),	varargout{1} = h;   end
	end

% ---------------------------------------------------------------------------------
function hObject = run_cmd_OF(varargin)

	if (isempty(varargin)),		return,		end
 
	hObject = figure('Vis','off');
	run_cmd_LayoutFcn(hObject);
	handles = guihandles(hObject);
	move2side(hObject,'right')
 
	handlesMir = varargin{1};
	if (handlesMir.no_file || handlesMir.image_type == 20)
		set([handles.radio_onGrid handles.radio_onImage], 'Val',0, 'Enable', 'off')
		set([handles.edit_com handles.edit_true], 'Enable', 'off')
	elseif (handlesMir.validGrid)
		set(handles.radio_onGrid,'Val',1)
	else
		set(handles.radio_onGrid,'Enable','off')
		set(handles.radio_onImage,'Val',1,'Enable','inactive')
	end

	handles.hMirFig1 = handlesMir.figure1;
	handles.image_type = handlesMir.image_type;
	handles.hCallingAxes = handlesMir.axes1;
	handles.hImg = handlesMir.hImg;
	try		handles.head = handlesMir.head;		end
	handles.image_type = handlesMir.image_type;
	handles.imgSize = size(get(handles.hImg,'CData'));
	handles.path_tmp = handlesMir.path_tmp;
	handles.IamCompiled = handlesMir.IamCompiled;
	handles.isTrue = 1;

	% Add this figure handle to the carra�as list
	plugedWin = getappdata(handles.hMirFig1,'dependentFigs');
	plugedWin = [plugedWin hObject];
	setappdata(handles.hMirFig1,'dependentFigs',plugedWin);

	str = sprintf(['If as a result of the applied MATLAB command (equation)\n' ...
					'one get a logical array (with ones where condition is TRUE\n' ...
					'and zero otherwise) one can set the TRUE value to a different\n' ...
					'value than 1, but in the [1 255] range . This is useful when one\n' ...
					'want to combine several mask files and having each individual\n' ...
					'contribution be identified for example with an unique color.']);
	set([handles.text_true handles.edit_true],'ToolTip', str)		

	str = sprintf(['Enter a valid MATLAB command as you would do in the ML command prompt.\n' ...
					'In the command you enter the array being processed, either an image\n' ...
					'or the underlying grid as selected from the radio boxes above, is\n' ...
					'referred as the variable Z. You MUST stick to this convention.\n\n' ...
					'Simple examples:\n' ...
					'- to multiply the displayed grid by 10\n' ...
					'Z * 10\n' ...
					'- create a mask where values in the [0 5] interval are set to 1\n' ...
					'Z > 0 && & Z < 5    (ignore the underscore, it''s a ML bug)\n' ...
					'- Put to white the blue channel of the displayed image (select "Apply to Image")\n' ...
					'Z(:,:,3) = 255']);
	set(handles.edit_com,'ToolTip', str)		

	str = sprintf(['This is a tool where you can enter an arbitrarily complicated MATLAB\n' ...
					'single line expression that manipulates either the underlying grid\n' ...
					'(in case you loaded one) or the displayed image. NOTE, in case of the\n' ...
					'displayed image is indexed, it is converted to RGB prior to any manipulation\n\n' ...  
					'The only constrain is that you give a valid ML command. In case of error,\n' ...
					'the error message won''t probably be of much help']);
	set(handles.push_whatIsThis,'ToolTip', str)		

	guidata(hObject, handles);
	set(hObject,'Visible','on');

	if (nargin > 1),	external_drive(handles, 'griding_mir', varargin{2:end}),	end

% -----------------------------------------------------------------------------------------
function push_compute_CB(hObject, handles)
% ...

	% Try first to run any eventual command present in handles.edit_com2
	com2 = ddewhite(get(handles.edit_com2, 'String'));
	if (~isempty(com2))
		ind = strfind(com2, '(');
		try
			if (~isempty(ind) && com2(end) == ')')
				fun_CB = str2func(com2(1:ind(1)-1));
				com2 = ddewhite(com2(ind(1)+1:end-1));
				if (isempty(com2))					% Function with no args
					feval(fun_CB);
				else
					ind = strfind(com2, ',');
					arg = cell(numel(ind)+1,1);
					com2 = strrep(com2, ',', ' ');
					[arg{1},r] = strtok(com2);
					k = 2;
					while (~isempty(r))
						[arg{k},r] = strtok(ddewhite(r));
						k = k + 1;
					end
					feval(fun_CB, arg{:});
				end
			else
				eval(com2);
			end
			msgbox(['Sucessefuly run the comand:  ', com2])
		catch
			errordlg(lasterr, 'Error')
		end
		return
	end

	com = get(handles.edit_com, 'String');
	if (isempty(com)),	return,		end			% Idiot call
	com = [com ';'];

% 	fname = 'runCmd_cmd.m';
% 
% 	% Write the running command in a temporary file (This was an experimental idea, which is not in use)
% 	fid = fopen(fname,'w');
% 	fprintf(fid,'function Z = runCmd_cmd(arg1)\n');
% 	fprintf(fid,'Z = arg1.Z;\n');
% 	fprintf(fid,'claZ = [];\n');			% In case we need it to know if the fck doubles tirany came on ground
% 	fprintf(fid,'try\n\t%s\n', com);		% Exec the command in a try wraper
% 	fprintf(fid,'catch\n');
% 	fprintf(fid,'\tle = lasterr;\n');
% 	fprintf(fid,'\tind = strfind(le, ''values of class'');\n');	% Screwed. Use lasterr to see if it was due to fck double issue
% 	fprintf(fid,'\tif (~isempty(ind))\n');
% 	fprintf(fid,'\t\tZ = double(Z);\n');		% Try again with fck doubles
% 	fprintf(fid,'\t\tclaZ = le(ind+17:end-2);\n\tend\n');	% Signal that we have to convert from doubles
% 	fprintf(fid,'\ttry\n\t\t%s\n\tend\n', com);
% 	fprintf(fid,'end\n');
% 
% 	% Check if we had class algebra problem (fck doubles)
% 	fprintf(fid,'if (~isempty(claZ))\n');						% Yes we had a fck doubles shit
% 	fprintf(fid,'\tif (strcmp(claZ,''single''))\n');
% 	fprintf(fid,'\t\tZ = single(Z);\n');		% Singles in original, convert back to them 
% 	fprintf(fid,'\telseif (strcmp(claZ,''int16''))\n');
% 	fprintf(fid,'\t\tZ = int16(Z * (2^16  - 1) -2^16 / 2 );\n');% Int16 in original		-- Not sure of this
% 	fprintf(fid,'\telseif (strcmp(claZ,''uint16''))\n');
% 	fprintf(fid,'\t\tZ = int16(Z * (2^16 - 1));\n');			% UInt16 in original 
% 	fprintf(fid,'\telseif (strcmp(claZ,''uint8''));\n');
% 	fprintf(fid,'\t\tZ = uint8(Z * 255)\n');					% UInt8 in original 
% 	fprintf(fid,'\telseif (strcmp(claZ,''int8''));\n');
% 	fprintf(fid,'\t\tZ = int8(Z * 255 - 127)\n');				% Int8 in original 		-- Not sure of this
% 	fprintf(fid,'\tend\n');
% 	fprintf(fid,'end\n');
% 	fclose(fid);
% 	pause(0.01);		% Otherwise it's too fast for feval() below
% 	builtin('delete',fname);

	% See if we are operating on a grid ...
	if (strcmp(get(handles.radio_onGrid, 'Enable'), 'on') && get(handles.radio_onGrid, 'Val'))
		handles.figure1 = handles.hMirFig1;		% it won't hurt as long as we don't save the handles
		[X,Y,Z] = load_grd(handles);
		if isempty(Z),  return,		end			% An error message was already issued
	else										% Nope. Doing things on a image 
		Z = get(handles.hImg,'CData');
		if (ndims(Z) == 2 && get(handles.radio_onImage,'Val') && ~isa(Z,'logical'))		% Convert to RGB
			if (strncmp(com, 'sum', 3) && (max(Z(:)) == 1))
				Z = logical(Z);
			else
				Z = ind2rgb8(Z,get(handles.hMirFig1,'Colormap'));
			end
		end
		X = handles.head(1:2);		Y = handles.head(3:4);
	end

	try
		is_1D = false;
		cb = str2func('runCmd_cmda');
		if (strncmp(com, 'sum(', 4))
			Z(isnan(Z)) = 0;
			is_1D = true;
		end

		if (handles.IamCompiled)		% PARTICULAR CASES FOR CLASSES
			if (~isempty(strfind(com, 'Z >')) || ~isempty(strfind(com, 'Z>')))
				if (com(end) == ';'),	com(end) = [];		end		% We don't want the trailing ';' here
				ind = strfind(com, '>');
				thresh = str2double(com(ind(1)+1:end));
				Z_out = Z > thresh;
			elseif (is_1D)
				ind1 = strfind(com, ',');
				ind2 = strfind(com, ')');
				dim = str2double(com(ind1+1:ind2-1));
				Z_out = sum(Z, dim);
			else
				warndlg('In the compiled version only a very limmited set of operations work. Unfortunately not this one.','Warning')
				return
			end
		else
			arg1.Z = Z;
			Z_out = feval(cb,arg1,com);
			if (size(Z,3) == 3)
				Z_out = squeeze(Z_out);
			end
		end
	catch
		errordlg(['It didn''t work: ' lasterr],'Error'),		return
	end

	% A catch point for the 'sum' (1D) case
	if (is_1D)
		s = size(Z_out);
		if (s(1) == 1)
			ecran(linspace(X(1),X(end),size(Z_out,2)), Z_out)
		elseif (s(2) == 1)
			ecran(linspace(Y(1),Y(end),size(Z_out,1)), Z_out)
		else
			errordlg('The sum operation can not be used with this type of data','Error')
		end
		return
	end

	% Update the Z_out min/max
	head = handles.head;
	if (isa(Z_out,'single')),	zz = grdutils(Z_out,'-L');			head(5:6) = [zz(1) zz(2)];
	else,						head(5) = double(min(Z_out(:)));	head(6) = double(max(Z_out(:)));
	end
	if (isa(Z_out,'logical'))
		if (handles.isTrue ~= 1)	% Well, what else to say ---- true = handles.isTrue
			Z_out(Z_out) = handles.isTrue;
		end
		figTitle = 'Mask image';
	elseif (isa(Z_out,'single')),	figTitle = 'Refactored grid';
	else,							figTitle = 'Zorro image';
	end

	tmp.X = X;		tmp.Y = Y;		tmp.head = head;	tmp.name = figTitle;
	handles.figure1 = handles.hMirFig1;		% it won't hurt as long as we don't save the handles
	prjInfStruct = aux_funs('getFigProjInfo',handles);
	if (~isempty(prjInfStruct.projWKT))
		tmp.srsWKT = prjInfStruct.projWKT;
	end
	mirone(Z_out, tmp)

% -----------------------------------------------------------------------------------------
function Z = runCmd_cmda(arg1,cmd)
	Z = arg1.Z;
	claZ = [];
	try
		Z = eval(cmd);
	catch
		le = lasterr;
		ind = strfind(le, 'values of class');
		if (~isempty(ind))
			Z = double(Z);
			claZ = le(ind+17:end-2);		% Signal that we have to convert from doubles
		end
		try
			Z = eval(cmd);
		catch
			errordlg(['Failed to run command. Probably you are running the compiled version. Error message was: ' lasterr],'ERROR')
		end
	end
	if (~isempty(claZ))
		if (strcmp(claZ,'single'))
			Z = single(Z);
		elseif (strcmp(claZ,'int16'))
			Z = int16(Z * (2^16  - 1) -2^16 / 2 );
		elseif (strcmp(claZ,'uint16'))
			Z = int16(Z * (2^16 - 1));
		elseif (strcmp(claZ,'uint8'))
			Z = uint8(Z * 255);
		elseif (strcmp(claZ,'int8'))
			Z = int8(Z * 255 - 127);
		end
	end

% -----------------------------------------------------------------------------------------
function radio_onImage_CB(hObject, handles)
	if (~get(hObject,'Value')),		set(hObject,'Value',1),		return,		end
	set(handles.radio_onGrid,'Val',0)

% -----------------------------------------------------------------------------------------
function radio_onGrid_CB(hObject, handles)
	if (~get(hObject,'Value')),		set(hObject,'Value',1),		return,		end
	set(handles.radio_onImage,'Val',0)

% -----------------------------------------------------------------------------------------
function edit_true_CB(hObject, handles)
	xx = str2double(get(hObject,'String'));
	if (isnan(xx))
		errordlg('Please, don''t try to be smart - IDIOT','Chico Clever')
		set(hObject,'String',1)
		handles.isTrue = 1;
	else
		xx = min( abs(xx), 255);
		set(hObject, 'String', xx)
		handles.isTrue = xx;
	end
	guidata(handles.figure1)

% --- Creates and returns a handle to the GUI figure. 
function run_cmd_LayoutFcn(h1)

DY = 30;

set(h1,'Position',[520 657 409 171],...
'Color',get(0,'factoryUicontrolBackgroundColor'),...
'MenuBar','none',...
'Name','Run command',...
'NumberTitle','off',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1');

uicontrol('Parent',h1, 'Position',[10 117+DY 105 16],...
'Callback',@run_cmd_uiCB,...
'FontName','Helvetica',...
'String','Apply to Image',...
'Style','radiobutton',...
'Tooltip','If checked, the command will be applyied to the displayed image',...
'Tag','radio_onImage');

uicontrol('Parent',h1, 'Position',[305 118+DY 95 16],...
'Callback',@run_cmd_uiCB,...
'FontName','Helvetica',...
'String','Apply to Grid',...
'Style','radiobutton',...
'Tooltip','If checked, the command will be applyied to the underlying grid',...
'Tag','radio_onGrid');

uicontrol('Parent',h1,'BackgroundColor',[1 1 1],'Position',[10 63+DY 391 51],...
'HorizontalAlignment','left',...
'Max',3,...
'Style','edit',...
'Tag','edit_com');

uicontrol('Parent',h1, 'Position',[10 40+DY 265 16],...
'FontName','Helvetica',...
'HorizontalAlignment','left',...
'String','If command is a logical expression, TRUE will be set to',...
'Style','text',...
'Tag','text_true');

uicontrol('Parent',h1, 'Position',[276 37+DY 35 21],...
'BackgroundColor',[1 1 1],...
'Callback',@run_cmd_uiCB,...
'String','1',...
'Style','edit',...
'Tag','edit_true');

uicontrol('Parent',h1,'BackgroundColor',[1 1 1],'Position',[10 41 391 21],...
'HorizontalAlignment','left',...
'Style','edit',...
'Tooltip','Try run a generic command, which may be a function call.',...
'Tag','edit_com2');

uicontrol('Parent',h1, 'Position',[10 10 91 21],...
'Enable','inactive',...
'FontName','Helvetica',...
'FontSize',9,...
'FontWeight','bold',...
'ForegroundColor',[0 0.502 0],...
'String',' What is this?',...
'Tag','push_whatIsThis');

uicontrol('Parent',h1, 'Position',[330 8 71 21],...
'Callback',@run_cmd_uiCB,...
'FontName','Helvetica',...
'FontSize',10,...
'String','Compute',...
'Tag','push_compute');

function run_cmd_uiCB(hObject, eventdata)
% This function is executed by the callback and than the handles is allways updated.
	feval([get(hObject,'Tag') '_CB'],hObject, guidata(hObject));
