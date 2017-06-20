%% generat N-fold data representation matrix from IDVec. IDVec is a column vector containing all the IDs.
% collect person (in relation matrix, person means the first dimension, item means the second dimension)
% which has at least M related items and then divide the whole collected person set into N folds. (N-fold cross validation)
% IDVec: all the persons
% 
% foldNum:
%
% fileName: the file which will store the divided personIDs.
%
% IDPerFold: return matrix representing the personIDs in each fold. the row
% number is the foldNum, the column number is equal to the maximum persons
% in the folds. Value 0 represents invalid personIDs (should delete these 0s when using the IDPerFold matrix).
%%
function [IDPerFold] = genNFoldIDs(IDVec, foldNum, fileName)
    %
    IDNum = size(IDVec, 1);
    IDNumPerFold = floor(IDNum / foldNum);
    IDPerFold = zeros(foldNum, IDNumPerFold + foldNum);
    %permIdx = randperm(IDNum); % useless for leave-one-validation
    %IDSet_perm = IDVec(permIdx, 1)';
IDSet_perm = IDVec;
    %
    for i = 1 : foldNum - 1
        IDPerFold(i, 1 : IDNumPerFold) = IDSet_perm(1 + (i - 1) * IDNumPerFold : i * IDNumPerFold);
    end
    IDPerFold(foldNum, 1 : IDNum - (foldNum - 1) * IDNumPerFold) = IDSet_perm((foldNum - 1) * IDNumPerFold + 1 : IDNum);
    %save('D:/lab_case/cb/experiments/disease_target/data/dis_dis_sim/NFoldDisIDs.txt', 'personPerFold', '-ascii');
    %save(fileName, 'IDPerFold', '-ascii');
end