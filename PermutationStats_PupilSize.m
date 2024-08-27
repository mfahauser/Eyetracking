%% permutation testing
 Diff=PdevPupil-BLPupil;

 nums = randi([0 1], 25, 1000)*-1;
 nums(nums==0)=1;
for Time=1:size(Diff,2)
   [h,p,ci,stats]=ttest(Diff(:,Time));
   Real=stats.tstat;
   for i =1:1000
   PermDiff=Diff(:,Time).*nums(:,i);
   [h,p,ci,stats]=ttest(PermDiff);
   Perm(1,i)=stats.tstat;
   end
   
   SortPerm=sort(Perm,'descend');
   if Real>SortPerm(1,50)
       SigTime(Time)=1;
   end
end

   