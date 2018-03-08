% USAGE: square_wave_project ([T, [num, [max, [min, [start, [state]]]]]])

clear;

% VARIABLES			DESCRIPTIONS
T_default = 1		% period
num_default = 100	% number of addends to compute
max_default = 5		% high value
min_default = -5	% low value
start_default = 0	% starting time	
state_default = 0	% starting state (1 or 0)

function [] = square_wave_project (varargin)
	% if there is more coputing power, increase these
	periods = 3;	% number of periods to display
	points = 500;	% number of points each second, recommend at least 500
	default_num = 100;
	
	% get the default values for unstated options
	[T, num, max, min, start, state] = default_options(default_num, varargin);
	
	t = linspace(start, start+periods*T, points*periods*T);
	[f, cos_component, sin_component] = make_square_wave(T, num, max, min, start, state, t);
	
	visualization(f, t, cos_component, sin_component);
end

function [T, num, max, min, start, state] = default_options (default_num, varargin)
	% only want 6 optional inputs at most
	numvarargs = length(varargin{1});
	if numvarargs > 6
    error('square_wave_project:TooManyInputs', ...
        'requires at most 6 optional inputs');
	end
	
	% set defaults for optional inputs
	optargs = {T_default, num_default, max_default, min_default, start_default, state_default};
	
	% overwrite the default values with input values
	optargs(1:numvarargs) = varargin{1};

	% place optional args in memorable variable names
	[T, num, max, min, start, state] = optargs{:};
end

function [f, cos_component, sin_component] = make_square_wave (T, num, max, min, start, state, t)
	% f1=max if state=1, f1=min if state=0
	f1 = mod(state, 2)*max + (1 - mod(state, 2))*min;
	f2 = mod(state, 2)*min + (1 - mod(state, 2))*max;
    w = 2*pi/T;
	
	% initialize f with the first coefficient
	a0 = (max + min)/2;
	for i=1 : length(t)
		f(i) = a0;
	end
	
	% calculate the coefficient for the addends
	for(i=1 : num)
		aN(i) = 2*(f1-f2)*(sin(i*w*(start+T/2))-sin(i*w*start))/(w*i*T);
		bN(i) = -2*(f1-f2)*(cos(i*w*(start+T/2))-cos(i*w*start))/(w*i*T);
		for j=1 : length(t)
			cos_component(i, j) = aN(i)*cos(i*w*t(j));
			sin_component(i, j) = bN(i)*sin(i*w*t(j));
			f(j) = f(j) + cos_component(i, j) + sin_component(i, j);
		end
	end
end

function [] = visualization (f, t, cos_component, sin_component)
	figure(1);
    clf;
    hold on;
    grid on;
	plot(t, f, 'b-');
	for i=1 : size(cos_component, 1)
		plot(t, cos_component(i,:), 'r-');
		plot(t, sin_component(i,:), 'm-');
	end
end