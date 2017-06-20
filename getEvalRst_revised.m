%% get evaluation result from predicted results.
% evaluation result store the predicted position of an item for a person (the position excludes other training items.)
%
% evalRst: the first column is the personID, the second column is the
% predicted position, the third column is the total number of items for
% each person.
%
% orgRelation: the original relation matrix.
%
% predictedRelation: the predicted relation matrix.
%
% relationOnTest: the testing persons and their corresponding testing items.
%
% coreDrugIdx: the core drugs in the disease-drug matrix.
%%
function [evalRst] = getEvalRst_revised(orgRelation, predictedRelation, relationOnTest)
    testPersonNum = size(relationOnTest, 1);
    evalRst = zeros(testPersonNum, 3);
    
    for testPersonNo = 1 : testPersonNum
        %trainItemNum = sum(orgRelation(relationOnTest(testPersonNo, 1), :), 2) - 1; % training item number for this person.

trainSet = orgRelation(relationOnTest(testPersonNo, 1), :); % all originally connected items.
trainSet(relationOnTest(testPersonNo, 2)) = 0; % set the testing item as not connected.
trainItemIdx = find(trainSet);

        %[s1, s2] = sort(predictedRelation(relationOnTest(testPersonNo, 1), find(trainSet)), 2, 'descend');
[s1, s2] = sort(predictedRelation(relationOnTest(testPersonNo, 1), :), 2, 'descend');
        %s2 = s2(ismember(s2, coreItemIdx)); % only count core items.
%s2 = s2 - relationOnTest(testPersonNo, 2);
[C, ia] = setdiff(s2, trainItemIdx);
clear C;
        rstPos = find(~(s2(sort(ia)) - relationOnTest(testPersonNo, 2)));
        %
        evalRst(testPersonNo, 1) = relationOnTest(testPersonNo, 1);
        if size(rstPos,2) == 0
            fprintf('here!');
        end
evalRst(testPersonNo, 2) = rstPos;
evalRst(testPersonNo, 3) = size(orgRelation, 2) - size(trainItemIdx, 2);
        %evalRst(testPersonNo, 3) = size(orgRelation, 2);
        %evalRst(testPersonNo, 3) = size(coreItemIdx, 2);
        %if (rstPos <= trainItemNum)
            % the predicted position is better than existing items. denote
            % this as ranked 1st.
        %    evalRst(testPersonNo, 2) = 1;
        %else
        %    evalRst(testPersonNo, 2) = rstPos - trainItemNum;
        %end
    end
end