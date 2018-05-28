function [X, Y, Z, head, misc] = c_grdread(fname, varargin)
% Temporary function to easy up transition from GMT4 to GMT5.2

% MISC - (GMT5 only) - is a struct with:
%		'desc', 'title', 'history', 'srsWKT', 'strPROJ4' fields

% $Id$
	
	Zout = gmtmex(['read -Tg ' fname]);
	X = Zout.x;
	Y = Zout.y;
	Z = Zout.z;
	head = [Zout.range Zout.registration Zout.inc 0];	% Old grdread_m kept trace of data type on 10th element to preserve int16 types
	misc = struct('desc',Zout.comment,'title',Zout.title,'history',Zout.command,'srsWKT',Zout.wkt,'strPROJ4',Zout.proj4);
	gmtmex('destroy')
