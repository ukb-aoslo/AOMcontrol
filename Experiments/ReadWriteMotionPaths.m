% --------------------------------------------------------------------------------------
% ****************************  Read and Write motionpaths  ****************************
% --------------------------------------------------------------------------------------

close all
clear all

%% Read - "Luke Filewalker"

answerUmfang = questdlg('Analysis options','Extent','Single trial','Single subject','All subjects','Single subject');

    
if strcmp(answerUmfang,'Single trial');
    disp(answerUmfang)
    trialPath = uigetdir('D:\MotionPaths');
    numOfSubjects = 1;
    numOfTrials = 1;
	N4M3 = trialPath(16:25);
elseif strcmp(answerUmfang,'Single subject');
    disp(answerUmfang)
    subjectPath = uigetdir('D:\MotionPaths');
    numOfSubjects = 1;
    numOfTrials = 0;
    N4M3 = subjectPath(16:25);
elseif strcmp(answerUmfang,'All subjects');
    disp(answerUmfang)
    AllPathsPath = uigetdir('D:\MotionPaths');
    subjectsList = dir(AllPathsPath);
    subjectsList = subjectsList(3:end);
    numOfSubjects = size(subjectsList,1);
    numOfRuns = 0;
    N4M3 = 'All';
else
    disp('FAIL')
end

AllPaths = zeros (22,2);
NumberN = 1;
Count = 0;

%% Loop subjects
for zzz = 1:numOfSubjects
    if  numOfSubjects == 1 || subjectsList(zzz).isdir == 1  % folders only
        if numOfSubjects >1
            subjectPath = [subjects_Path '\' subjects_List(zzz,1).name];
        end
        
        if numOfTrials ~=1
            TrialList = dir(subjectPath);
            TrialList = TrialList(3:end);
            numOfTrials = size(TrialList,1);
        end
        
        
        %% Loop days
        for yyy = 1:numOfTrials
%             disp(yyy)
            if numOfTrials == 1 || TrialList(yyy).isdir == 1
                if numOfTrials >1
                    trialPath = [subjectPath '\' TrialList(yyy,1).name];
                end
                
                DataList = dir(trialPath);
                DataList = DataList(3:end);
                
                for xxx = 1:size(DataList,1)
                    PathData = importdata([trialPath '\' DataList(xxx,1).name]);
                    if size(PathData,1)<22
                        PathData(size(PathData,1)+1:22,:)= NaN;
                        AllPaths (:,:,NumberN) = PathData;
                        NumberN = 1+ NumberN;
                    elseif size(PathData,1)==22
                        AllPaths (:,:,NumberN) = PathData;
                        NumberN = 1+ NumberN;
                    elseif size(PathData,1)>22
                        Count = Count +1;
                    end
                    clear PathData
                end
            end     
        end
    end
end
disp(Count)    

%% Write - "Darth Saver"

save(['D:\MotionPaths\MotionPaths' (N4M3) '.mat'],'AllPaths')


%% End
clear all
close all