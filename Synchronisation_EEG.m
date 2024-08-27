%% Requires eye_eeg plugin for eeglab
for i=[207 208 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226] %partici?atr loop

    
load (['Data\' num2str(i) '_Raw Data_2.dat'])
save(['' num2str(i) '.mat'], ['X' num2str(i) '_Raw_Data_2'])


%%% Remove header and prepare markerfile for EEGLAB
fid = fopen(['Data\' num2str(i) '_Raw Data_2.vmrk']);
fidd= fopen(['' num2str(i) '_eegmarkers.txt'],'w');
% fidd=fopen(fidd,'w')
% fid=fopen(fid)
line=1
markend='[Marker User Infos]'
fprintf(fidd,'%s \t %s\n \r\n','number,rtype,type,latency,misc,misc2') ;
while ~feof(fid);
    tline=fgets(fid);
    if not(isempty(strfind(tline,markend)));
        markend=1
    elseif markend==1
    elseif line>16
        tline=strrep(tline,'S ','');
        tline=strrep(tline,'S','');
        %fwrite(fidd,tline) ;
        fprintf(fidd,'\r\n %s \t %s\n', tline)
    end
    line=line+1
end
fclose(fidd);


mydata = textscan(fid, '%s %s %s %s %s');

C = textread(['' num2str(i) '_eegmarkers.txt'], '%s','delimiter', '\n');

%%%%% To detect whether start trials were lost
E=C{2}
remain=E
for bla=1:2
[token, remain]=strtok(remain, ',');
token
end
E=token;
E=str2num(E);

if E<=10 || E>=171
IndexC = strfind(C, warp);
Index = find(not(cellfun('isempty', IndexC)));
D=Index(1,1) 
E=C{D}
remain=E
for bla=1:2
[token, remain]=strtok(remain, ',');
token
end
E=token;
else
%%%% End of start-trial detect %%%%

% IndexC = strfind(C, warp);
% Index = find(not(cellfun('isempty', IndexC)));
IndexC=regexp(C,',1\w\w,','match')

Index = find(not(cellfun('isempty', IndexC)));

D=Index(1,1) 
E=C{D}
remain=E
for bla=1:2
[token, remain]=strtok(remain, ',');
token
end
E=token;
end


IndexEnd = strfind(C, '98,'); 
Index = find(not(cellfun('isempty', IndexEnd)));
le=length(Index);
End=Index(le,1)
H=98 % C{End}(18:20)%turns out object number that ended



C = textread(['Eyelink\' num2str(i) '.asc'], '%s','delimiter', '\n');
 F=str2num(E)
IndexC = strfind(C, ['' num2str(F) '_1']);
Index = find(not(cellfun('isempty', IndexC)  ));
D=Index(1,1)
G=C{D}(4:11) 
G=str2num(G)
event(1,1)=G; %Starttime
event(1,2)=F; %Startevent
K=H    %str2num(H)
IndexEnd = strfind(C, ['' num2str(K) '_1']);
Index = find(not(cellfun('isempty', IndexEnd)));
le=length(Index);
D=Index(le,1)
G=C{D}(4:11);
G=str2num(G)
event(2,1)=G; %Endtime
event(2,2)=K; %Endevent
save('event.mat','event');



eeglab

ET = parseeyelink(['J:\\Study 2.0\\Eyelink\' num2str(i) '.asc'],['J:\\Study 2.0\\' num2str(i) '_events.mat'],'!V TRIAL_VAR independent_variable_1');

eeglab

EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',['J:\\Study 2.0\\' num2str(i) '.mat'],'setname','20','srate',500,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG=pop_chanedit(EEG, 'lookup','J:\\Rat EEG Valentina\\analysis_with Niko_15.11.13\\scripts\\eeglab13_3_2b\\plugins\\dipfit2.3\\standard_BESA\\standard-10-5-cap385.elp','load',{'J:\\Study 2.0\202_Av_7. Wdh.xyz' 'filetype' 'autodetect'});

EEG = pop_importevent( EEG, 'event',['J:\\Study 2.0\\' num2str(i) '_eegmarkers.txt'],'fields',{'number' 'type' 'latency' 'misc' 'misc2'},'skipline',1,'timeunit',NaN);


EEG = pop_importeyetracker(EEG,['J:\\Study 2.0\\' num2str(i) '_events.mat'],[F 98] ,[1:4] ,{'TIME' 'R_GAZE_X' 'R_GAZE_Y' 'R_AREA'},0,1,0,1) %Use Index vars here and skip event stuff from before
fn=['' num2str(i) '.png']
%print -dpng (fn
fig=2
saveas(figure(fig),fn,'jpg')
EEG = pop_saveset( EEG, 'filename',['' num2str(i) '_synchron_done.set'],'filepath','J:\\Study 2.0\\Eyelink\\');
fig=fig+1

eeglab redraw
clearvars -EXCEPT i fig
end

