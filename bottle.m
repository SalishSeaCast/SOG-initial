clear all
here=cd;
stn='S3';
cd /ocean/shared/SoG/btl
depth=[];

cruise={'02-01','02-02','02-03','02-04','02-06','02-07','02-08','02-09','02-10','03-01',...
     '03-02','03-03','03-04','03-05','03-06','03-07','03-08','03-09','03-14','03-15',...
     '03-18','03-20','03-21','03-22','04-01','04-02','04-03','04-04','04-05','04-06',...
     '04-07','04-08','04-09','04-10','04-11','04-12','04-13','04-14','04-15','04-16',...
     '05-01','05-02','05-03','05-04','05-05','05-06','05-07','05-09'};

nuts=struct('comment','nutrients and chl from SOG bottle data','cruise',{cruise},'depth',zeros(length(cruise),4),'no3',zeros(length(cruise),4),'si',zeros(length(cruise),4),'po4',zeros(length(cruise),4),'chl_200',zeros(length(cruise),4),'chl_020',zeros(length(cruise),4),'chl_002',zeros(length(cruise),4),'chl_total',zeros(length(cruise),4));


for i=1:length(cruise)
  cd(cruise{i});
  x=cruise{i};
  fid=fopen(['bottle_',x([1:2,4:5]),'.txt']);

k=1;
l=fgets(fid);

while ~feof(fid) & (length(l)<5 | ...
      (length(l)==1 & l(1)~=-1) | ...
     (length(l)>5 & isempty(findstr([stn ' '],l(1:5))))),
        l=fgetl(fid);
    if length(l)>=2 & l(1)=='*',
        l=[l ' ']; 
        fb=find(l==' ');
        fb(diff(fb)==1)=[];
        nval=sscanf(l(2:fb(1)),'%d'); 
        for k=1:nval,
           bott.varlabel{i,k}=deblank(l(fb(k)+1:fb(k+1)));
        end;    
    end        
end;

nsamp=sscanf(l(5:end),'%d',1);

vals=fscanf(fid,'%f',[nval nsamp]); % 

if ~isempty(nsamp) 

   for k=1:length(bott.varlabel(i,:))
     if isstr(bott.varlabel{i,k}) 
	eval(['bott.' bott.varlabel{i,k} '=vals(k,:);']);
   end; end
   
    if isempty(nsamp)
         bott=[];
     end;

	 if length(bott.depth)==3;
	 bott.depth=[bott.depth NaN];
	 bott.no3=[bott.no3 NaN];
	 bott.si=[bott.si NaN];
	 bott.po4=[bott.po4 NaN];
	 bott.chl002=[bott.chl002 NaN];bott.chl020=[bott.chl020 NaN];bott.chl200=[bott.chl200 NaN];
	 end

nuts.depth(i,:)=bott.depth;
nuts.no3(i,:)=bott.no3;
nuts.si(i,:)=bott.si;
nuts.po4(i,:)=bott.po4;
nuts.chl_200(i,:)=bott.chl200;
nuts.chl_020(i,:)=bott.chl020-bott.chl200;
nuts.chl_002(i,:)=bott.chl002-bott.chl020;
nuts.chl_total(i,:)=bott.chl002;
end; 

cd ..
fclose(fid);
end  %for i=... 
cd(here)

save nuts.mat nuts





