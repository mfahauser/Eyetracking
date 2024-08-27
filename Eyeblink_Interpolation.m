%Script to interpolate (50 ms before to 50 ms after eyeblinks) and baseline pupil size
clear all
clc
%%%%%%%%%%%% Baselining script %%%%%%%%%%%%%%%
for i =[202:208 210:226 228 229] %Participant loop

    %Load EEG & Eyetracking data
eeglab
EEG = pop_loadset('filename',['' num2str(i) '_synchron_done.set'],'filepath','J:\\Study 2.0\\Eyelink\\');


count=1
for c=66:68; % ET-channel (66=x-coordinates, 67=y-coordinates, 68= pupil-size)

n = 300; %maximum time an eyeblink can last and still be interpolated
x = 0;
V = EEG.data(c,1:length(EEG.data)); %get data out of EEG data frame


b = (V == x); % create boolean array: ones and zeros
d = diff( [0 b 0] );  % turn the start and end of an interpol period into +1 and -1
startRun = find( d==1 );
endRun = find( d==-1 );
runlength = endRun - startRun;

answer = find(runlength < n);
if answer >= 1;
  for round=1:length(answer)
      if startRun(1,1)==1 && answer(1,1)==1
          round=round+1
      end
      
%    for ebc=1:length(runlength(1,answer(1,round)));    % eye-blink counter
    %%%%%% Interpolation %%%%%
    xs = [(startRun(1,answer(1,round))-50), (endRun(answer(1,round))+50)]; %get time-points to interpolate before and after blink
    ys = [mean(V(1, (startRun(answer(1,round))-60):(startRun(answer(1,round))-50))), mean(V(1, (endRun(answer(1,round))+50):(endRun(answer(1,round))+60)))]; %get pupil-size before and after blink (averaged across 10 dp's)

% Interpolationspunkte 
    xi =xs(1):xs(2); 

% Interpolation 
    yi = interp1(xs, ys, xi); 

    V(1,xs(1):xs(2))=yi;
  end
  %return data to structure
    ALLEEG.data(c,:)=V; 
    EEG.data(c,:)=V;


else
end

end

EEG = pop_saveset( EEG, 'filename',['' num2str(i) '_synchron_done_EBs_Interpolated.set'],'filepath','J:\\Study 2.0\\Eyelink\\');
clearvars -except i
end

