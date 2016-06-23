function out = c_mapproject(data, varargin)
% Temporary function to easy up transition from GMT4 to GMT5.2

% $Id: c_mapproject.m 7928 2016-06-23 00:27:25Z j $

	global gmt_ver
	if (isempty(gmt_ver)),		gmt_ver = 4;	end		% For example, if calls do not come via mirone.m
	
	if (gmt_ver == 4)
		out = mapproject_m(data, varargin{:});
	else
		cmd = 'mapproject';
		for (k = 1:numel(varargin))
			cmd = sprintf('%s %s', cmd, varargin{k});
		end
		out = gmtmex(cmd, data);
		gmtmex('destroy')
	end
