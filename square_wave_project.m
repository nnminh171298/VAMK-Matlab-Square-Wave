function [] = square_wave_project (T, max, min, start, state, num)

	% f1=max if state=1, f1=min if state=0
	f1 = mod(state, 2)*max + (1 - mod(state, 2))*min;
    f2 = mod(state, 2)*min + (1 - mod(state, 2))*max;
    w = 2*pi/T;
	
	t = linspace(start, start+3*T, 500*3*T);
	a0 = (max + min)/2;
	
	% initialize f
	for i=1 : length(t)
		f(i) = a0;
	end
	
	for(i=1 : num)
		aN(i) = 2*(f1-f2)*(sin(i*w*(start+T/2))-sin(i*w*start))/(w*i*T);
		bN(i) = -2*(f1-f2)*(cos(i*w*(start+T/2))-cos(i*w*start))/(w*i*T);
		for j=1 : length(t)
			f(j) = f(j) + aN(i)*cos(i*w*t(j)) + bN(i)*sin(i*w*t(j));
		end
	end
	visualization(f, t);
	
end

function [] = visualization (f, t)
	
	figure(1);
    clf;
    hold on;
	plot(t, f, 'b-');
	
end