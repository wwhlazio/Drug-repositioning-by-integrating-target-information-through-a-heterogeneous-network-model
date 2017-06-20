%% calculate transMat = simMat1 * transMat * simMat2 iteratively (using wenhui's normalization method)
function [transMat] = twoMatPredict_multiply_noFilter(simMat1, simMat2, transMat)
    transMat_org = transMat;
    decay = 0.4;
    maxSim = 0.99;
    minSim = 0.3;
    % normalize ddMatrix(using wenhui's mehtod)
    simMat1(simMat1 > maxSim) = maxSim;
    simMat1(simMat1 < minSim) = 0;
    tmpEye = eye(size(simMat1));
    simMat1 = simMat1 + tmpEye;
%simMat1(simMat1 <= 1) = 0;
    simMat1(simMat1 > 1) = 1;
    norm_ddRow = sqrt(sum(simMat1, 2));
    norm_ddMat = norm_ddRow * norm_ddRow';
    simMat1 = simMat1 ./ norm_ddMat;
    clear norm_ddRow;
    clear norm_ddMat;
    clear tmpEye;

    % normalize rrMatrix(using wenhui's mehtod)
    simMat2(simMat2 > maxSim) = maxSim;
    simMat2(simMat2 < minSim) = 0;
    tmpEye = eye(size(simMat2));
    simMat2 = simMat2 + tmpEye;
%simMat2(simMat2 <= 1) = 0;
    simMat2(simMat2 > 1) = 1;
    norm_rrRow = sqrt(sum(simMat2, 2));
    norm_rrMat = norm_rrRow * norm_rrRow';
    simMat2 = simMat2 ./ norm_rrMat;
    clear norm_rrRow;
    clear norm_rrMat;
    clear tmpEye;
    %
fprintf('\n');
    for i = 1 : 10
        %fprintf('iteration on drMatrix %d\t\t', i);
        transMat_new = simMat1 * transMat * simMat2;
        transMat_new = decay * transMat_new + (1-decay) * transMat_org;
        %
        error = max(max(transMat_new - transMat));
        transMat = transMat_new;
        fprintf('error: %f\n', error);
        if error < 0.000001
            %break;
        end
    end
fprintf('\n');
end