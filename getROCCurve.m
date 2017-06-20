%% use the global resutls to calculate and draw ROC-curve
% the parameter of this function is gotten from calling of NFoldValidation function 
function[] = getROCCurve(globalRst)
    %
    result_rank_ratio = globalRst(:, 1) ./ globalRst(:, 2); % convert ranking to rank ratio
    %
    candidate_num = size(result_rank_ratio, 1);
    %
    maxRankNum = 1000;
    real_pos = candidate_num;
    real_neg = (maxRankNum - 1) * candidate_num;
    %% calculate FPR-FPR pairs
    ROC_curve = zeros(maxRankNum, 2); % (FPR, TPR)
    
    for rank = 1:maxRankNum
        TP = 0;
        FP = 0;
        for candidateNo = 1 : candidate_num
            if result_rank_ratio(candidateNo, 1) <= rank / maxRankNum
            	TP = TP + 1;
               	FP = FP + rank - 1;
            else
                FP = FP + rank;
            end
        end
        FPR = FP / (real_neg);
        TPR = TP / (real_pos);
        ROC_curve(rank, :) = [FPR, TPR];
    end
    %% draw the ROC curve
    figure;
    h1 = plot(ROC_curve(:,1), ROC_curve(:,2), 'linestyle', '-', 'linewidth', 2, 'color', 'b');
    set(gca,'XTick',0:0.1:1);
    xlabel('FPR');
    ylabel('TPR');
    grid on;
    title('ROC curve');
    %% calculate area under ROC curve (AUC)
    FPR = ROC_curve(:,1)';
    TPR = ROC_curve(:,2)';
    xdiff = diff(FPR);
    auc = 0.5 * sum((TPR(1:(maxRankNum - 1)) + TPR(2:maxRankNum)) .* xdiff); % upper point area
    fprintf('\nAUC is: %f\n', auc);
    %
    ROC_All = sprintf('ROC ALL, AUC: %f', auc);
    legend(h1, ROC_All, 'location', 'SouthEast');
end
