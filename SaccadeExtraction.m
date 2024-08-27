%%%% Script to parse Eyetracking Data, and extract saccade numbers for
%%%% different time-windows
clear all
cd('I:\Study 2.0\Eyelink')
FolderNames=dir('2*');
FolderNames=FolderNames(find(vertcat(FolderNames.isdir)),:);
eeglab


Baseline=[];
for i =1:length(FolderNames)
    
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename',[FolderNames(i,:).name '_synchron_done_EBs_Interpolated_NBR_filt_BLR_AveR_postICA.set'],'filepath',['I:\\Study 2.0\\Eyelink\\' FolderNames(i,:).name '\\']);
% [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = eeg_checkset( EEG );
EEG = pop_selectevent( EEG, 'type',7,'deleteevents','on','deleteepochs','on','invertepochs','off'); %take out one event type
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
if EEG.trials<40
    continue
end
try
EEG = pop_detecteyemovements(EEG,[],[66 67] ,6,4,0.031973,1,0,25,4,1,1,1) % extract saccades and fixations
catch
    continue
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EventCodes=squeeze(struct2cell(EEG.event))'; %convert structure with event codes and sacc. & fixation info to cell array
EventInfo=cell2mat(EventCodes(:,3:19)); %get all numerical info on each event
for j =1:length(EventInfo)%identify events as imageonset(0),saccade(1) or fixations(2)
    if EventInfo(j,9)~=0
    EventInfo(j,18)=1;
    elseif EventInfo(j,9)==0 & EventInfo(j,16)~=0
        EventInfo(j,18)=2;
    else
        EventInfo(j,18)=0;
    end
end

for j =1:length(unique(EventInfo(:,7))) %for each epoch go through and subtract the stimulus onset from event latencies
    EventInfo(EventInfo(:,7)==j,1)=EventInfo(EventInfo(:,7)==j,1)-EventInfo(EventInfo(:,7)==j & EventInfo(:,2)==1,1);
end
B=sortrows(EventInfo,1)
B(:,19)=i;
for TS=1:450
    TE=TS+50;
       Ind=B(:,1)<TE & B(:,1)>TS & B(:,18)==1;
    SaccadeAmp=mean(B(Ind,9))
    MeanBLSaccAmp(i,TS)=SaccadeAmp;
    SaccadeVel=mean(B(Ind,15))
    MeanBLSaccVel(i,TS)=SaccadeVel;
    
    SaccadeNumber=sum(B(:,1)<TE & B(:,1)>TS & B(:,18)==1)/size(unique(B(:,7)),1);
    MeanBLSaccades(i,TS)=SaccadeNumber;
end
Baseline=vertcat(Baseline, B(B(:,18)==1,:))

BLPupil(i,:)=mean(EEG.data(68,:,:),3);
% 
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0); 
end
close all
%% Same Thing for New objects
New=[]
for i =1:length(FolderNames)
    
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename',[FolderNames(i,:).name '_synchron_done_EBs_Interpolated_NBR_filt_BLR_AveR_postICA.set'],'filepath',['I:\\Study 2.0\\Eyelink\\' FolderNames(i,:).name '\\']);
% [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = eeg_checkset( EEG );
EEG = pop_selectevent( EEG, 'type',101:170,'deleteevents','on','deleteepochs','on','invertepochs','off'); %take out one event type
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
if EEG.trials<40
    continue
end
try
EEG = pop_detecteyemovements(EEG,[],[66 67] ,6,4,0.031973,1,0,25,4,1,1,1) % extract saccades and fixations
catch
    continue
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EventCodes=squeeze(struct2cell(EEG.event))'; %convert structure with event codes and sacc. & fixation info to cell array
EventInfo=cell2mat(EventCodes(:,3:19)); %get all numerical info on each event
for j =1:length(EventInfo)%identify events as imageonset(0),saccade(1) or fixations(2)
    if EventInfo(j,9)~=0
    EventInfo(j,18)=1;
    elseif EventInfo(j,9)==0 & EventInfo(j,16)~=0
        EventInfo(j,18)=2;
    else
        EventInfo(j,18)=0;
    end
end

for j =1:length(unique(EventInfo(:,7))) %for each epoch go through and subtract the stimulus onset from event latencies
    EventInfo(EventInfo(:,7)==j,1)=EventInfo(EventInfo(:,7)==j,1)-EventInfo(EventInfo(:,7)==j & EventInfo(:,2)==1,1);
end
B=sortrows(EventInfo,1)
B(:,19)=i;
for TS=1:450
    TE=TS+50;
       Ind=B(:,1)<TE & B(:,1)>TS & B(:,18)==1;
    SaccadeAmp=mean(B(Ind,9))
    MeanNwSaccAmp(i,TS)=SaccadeAmp;
    SaccadeVel=mean(B(Ind,15))
    MeanNwSaccVel(i,TS)=SaccadeVel;
    
    SaccadeNumber=sum(B(:,1)<TE & B(:,1)>TS & B(:,18)==1)/size(unique(B(:,7)),1);
    MeanNwSaccades(i,TS)=SaccadeNumber;
end
New=vertcat(Baseline, B(B(:,18)==1,:))
NewPupil(i,:)=mean(EEG.data(68,:,:),3);
% 
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0); 
end
close all
%% Same thing for Config Deviant Objects
CDev=[];
for i =1:length(FolderNames)
    
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename',[FolderNames(i,:).name '_synchron_done_EBs_Interpolated_NBR_filt_BLR_AveR_postICA.set'],'filepath',['I:\\Study 2.0\\Eyelink\\' FolderNames(i,:).name '\\']);
% [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = eeg_checkset( EEG );
EEG = pop_selectevent( EEG, 'type',1001,'deleteevents','on','deleteepochs','on','invertepochs','off'); %take out one event type
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
if EEG.trials<20
    continue
end
try
EEG = pop_detecteyemovements(EEG,[],[66 67] ,6,4,0.031973,1,0,25,4,1,1,1) % extract saccades and fixations
catch
    continue
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EventCodes=squeeze(struct2cell(EEG.event))'; %convert structure with event codes and sacc. & fixation info to cell array
EventInfo=cell2mat(EventCodes(:,3:19)); %get all numerical info on each event
for j =1:length(EventInfo)%identify events as imageonset(0),saccade(1) or fixations(2)
    if EventInfo(j,9)~=0
    EventInfo(j,18)=1;
    elseif EventInfo(j,9)==0 & EventInfo(j,16)~=0
        EventInfo(j,18)=2;
    else
        EventInfo(j,18)=0;
    end
end

for j =1:length(unique(EventInfo(:,7))) %for each epoch go through and subtract the stimulus onset from event latencies
    EventInfo(EventInfo(:,7)==j,1)=EventInfo(EventInfo(:,7)==j,1)-EventInfo(EventInfo(:,7)==j & EventInfo(:,2)==1,1);
end
B=sortrows(EventInfo,1)
B(:,19)=i;
for TS=1:450
    TE=TS+50;
       Ind=B(:,1)<TE & B(:,1)>TS & B(:,18)==1;
    SaccadeAmp=mean(B(Ind,9))
    MeanCDSaccAmp(i,TS)=SaccadeAmp;
    SaccadeVel=mean(B(Ind,15))
    MeanCDSaccVel(i,TS)=SaccadeVel;
    
    SaccadeNumber=sum(B(:,1)<TE & B(:,1)>TS & B(:,18)==1)/size(unique(B(:,7)),1);
    MeanCDSaccades(i,TS)=SaccadeNumber;
end
CDev=vertcat(Baseline, B(B(:,18)==1,:))
CdevPupil(i,:)=mean(EEG.data(68,:,:),3);
% 
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0); 
end
close all
%% Same thing for Persp Deviant Objects
PDev=[];
for i =1:length(FolderNames)
    
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
EEG = pop_loadset('filename',[FolderNames(i,:).name '_synchron_done_EBs_Interpolated_NBR_filt_BLR_AveR_postICA.set'],'filepath',['I:\\Study 2.0\\Eyelink\\' FolderNames(i,:).name '\\']);
% [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = eeg_checkset( EEG );
EEG = pop_selectevent( EEG, 'type',1002,'deleteevents','on','deleteepochs','on','invertepochs','off'); %take out one event type
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
if EEG.trials<20
    continue
end
try
EEG = pop_detecteyemovements(EEG,[],[66 67] ,6,4,0.031973,1,0,25,4,1,1,1) % extract saccades and fixations
catch
    continue
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EventCodes=squeeze(struct2cell(EEG.event))'; %convert structure with event codes and sacc. & fixation info to cell array
EventInfo=cell2mat(EventCodes(:,3:19)); %get all numerical info on each event
for j =1:length(EventInfo)%identify events as imageonset(0),saccade(1) or fixations(2)
    if EventInfo(j,9)~=0
    EventInfo(j,18)=1;
    elseif EventInfo(j,9)==0 & EventInfo(j,16)~=0
        EventInfo(j,18)=2;
    else
        EventInfo(j,18)=0;
    end
end

for j =1:length(unique(EventInfo(:,7))) %for each epoch go through and subtract the stimulus onset from event latencies
    EventInfo(EventInfo(:,7)==j,1)=EventInfo(EventInfo(:,7)==j,1)-EventInfo(EventInfo(:,7)==j & EventInfo(:,2)==1,1);
end
B=sortrows(EventInfo,1)
B(:,19)=i;
for TS=1:450
    TE=TS+50;
    Ind=B(:,1)<TE & B(:,1)>TS & B(:,18)==1;
    SaccadeAmp=mean(B(Ind,9))
    MeanPDSaccAmp(i,TS)=SaccadeAmp;
    SaccadeVel=mean(B(Ind,15))
    MeanPDSaccVel(i,TS)=SaccadeVel;
    
    SaccadeNumber=sum(B(:,1)<TE & B(:,1)>TS & B(:,18)==1)/size(unique(B(:,7)),1);
    MeanPDSaccades(i,TS)=SaccadeNumber;
end
PDev=vertcat(Baseline, B(B(:,18)==1,:))

PdevPupil(i,:)=mean(EEG.data(68,:,:),3);
% 
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0); 
end
close all


CDPmean=mean(bsxfun(@minus,CdevPupil,mean(CdevPupil(:,1:100),2)));
NPmean=mean(bsxfun(@minus,NewPupil,mean(NewPupil(:,1:100),2)));
PDPmean=mean(bsxfun(@minus,PdevPupil,mean(PdevPupil(:,1:100),2)));
BLPmean=mean(bsxfun(@minus,BLPupil,mean(BLPupil(:,1:100),2)));

figure(6)
plot(BLPmean)
hold on
plot(NPmean)
plot(CDPmean)
plot(PDPmean)


figure(7)
plot(nanmean(MeanBLSaccades))
hold on
plot(nanmean(MeanNwSaccades))
plot(nanmean(MeanCDSaccades))
plot(nanmean(MeanPDSaccades))

figure(8)
plot(nanmean(MeanBLSaccAmp))
hold on
plot(nanmean(MeanNwSaccAmp))
plot(nanmean(MeanCDSaccAmp))
plot(nanmean(MeanPDSaccAmp))

figure(9)
plot(nanmean(MeanBLSaccVel))
hold on
plot(nanmean(MeanNwSaccVel))
plot(nanmean(MeanCDSaccVel))
plot(nanmean(MeanPDSaccVel))

%     Ind=B(:,1)<TE & B(:,1)>TS & B(:,18)==1;
%     SaccadeAmp=mean(B(Ind,9))
%     MeanPDSaccAmp(i,TS)=SaccadeAmp;
%     SaccadeVel=mean(B(Ind,15))
%     MeanPDSaccVel(i,TS)=SaccadeVel;
%     

