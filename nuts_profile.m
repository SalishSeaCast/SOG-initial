load nuts.mat
      
no3=nuts.no3';
si=nuts.si';                  %'
depth=nuts.depth';
total_cruises=length(no3);
NO3 = zeros(81,total_cruises);
SI = zeros(81, total_cruises);


%---interploate to get data at every 0.5 meters--------------------------------

% Special Cruises (patch data)

% Cruise 1: only 3 data points: assume 20 m nitrate same downward
depth(4,1) = 30; 
no3(4,1)=no3(3,1); 
si(4,1)=si(3,1);

% Cruise 11: no 30 m data: assume 10 m nitrate same downward
no3(4,11) = no3(3,11);
si(4,11) = si(3,11);

% Cruise 35: 5 m nitrate data is negative
no3(2,35)=0;

% Cruise 45: there is no data!

for i=1:total_cruises;
     depth(5,i) = 40;
     no3(5,i)=no3(4,i);
     si(5,i) = si(4,i);
end

DEPTH = [0:0.5:40];
for i=1:total_cruises;
     NO3(:,i)=interp1(depth(:,i),no3(:,i),DEPTH)';    %'
     SI(:,i)=interp1(depth(:,i),si(:,i),DEPTH)';    %'
end

for i=1:total_cruises  
     if (i ~= 45) % not cruise 45 as no data then
        x = nuts.cruise{i}
        y = [DEPTH' NO3(:,1) SI(:,i)];         %'
	fid = ['Nuts_',x([1:2,4:5]),'.txt']
	save (fid,'y','-ascii')
     end
end




