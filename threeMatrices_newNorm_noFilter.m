%% calculate disease-target ranking using wenhui's normalization method
%function [] = threeMatrices_newNorm()
function [transMat12] = threeMatrices_newNorm_noFilter(transMat12, simMat1, simMat2, simMat3, transMat23)
%function [transMat23] = threeMatrices_newNorm(transMat23, simMat1, simMat2, simMat3, transMat12)
    decay = 0.4;
    max_sim = 0.99;
    min_sim = 0.3;
    %% filter ddMatrix
    simMat1(simMat1 > max_sim) = max_sim;
    simMat1(simMat1 < min_sim) = 0;
    tmpEye = eye(size(simMat1));
    simMat1 = simMat1 + tmpEye;
%simMat1(simMat1 <= 1) = 0;
    simMat1(simMat1 > 1) = 1;

    %% filter rrMatrix
    simMat2(simMat2 > max_sim) = max_sim;
    simMat2(simMat2 < min_sim) = 0;
    tmpEye = eye(size(simMat2));
    simMat2 = simMat2 + tmpEye;
%simMat2(simMat2 <= 1) = 0;
    simMat2(simMat2 > 1) = 1;

    % filter ttMatrix
    simMat3(simMat3 > max_sim) = max_sim;
    simMat3(simMat3 < min_sim) = 0;
    tmpEye = eye(size(simMat3));
    simMat3 = simMat3 + tmpEye;
%simMat3(simMat3 <= 1) = 0;
    simMat3(simMat3 > 1) = 1;

    %
    %D = simMat1 * simMat1;
    %D = D ./ ((sum(D,2) * sum(D,2)') .^ 0.5 + 0.001);
    %T = simMat3 * simMat3;
    %T = T ./ ((sum(T,2) * sum(T,2)') .^ 0.5 + 0.001);
    %
    %RR1 = rrMatrix * rtMatrix * T * rtMatrix' * rrMatrix ;
    %RR1 = RR1 ./ ((sum(RR1,2)*sum(RR1,2)').^0.5  + 0.001);

    RR1 = simMat2 * transMat23 * simMat3 * transMat23';
    RR1 = RR1 ./ ((sum(RR1,2)*sum(RR1,1)).^0.5  + 0.001);

    %
    RR2 = transMat12' * simMat1 * transMat12 * simMat2;
    RR2 = RR2 ./ ((sum(RR2,2) * sum(RR2,1)) .^ 0.5 + 0.001);
    %
    %DR2 = D * drMatrix * RR1;
    %RT2 = RR2 * rtMatrix * T;

    DR2 = transMat12 * RR1;
    RT2 = RR2 * transMat23;

    %
    DR1 = transMat12;
    RT1 = transMat23;
    %
fprintf('\n');
    for i = 1 : 10
        %fprintf('iteration %d\n', i);
        error = max(max(abs(DR2 - DR1)));
        error2 = max(max(abs(RT2 - RT1)));
        fprintf('DR convergence error: %f        RT convergence error: %f\n', error, error2);

        %while max(max(abs(DR2-DR1)))>0.001 && max(max(abs(RT2-RT1)))>0.001
        DR1 = DR2;
        RT1 = RT2;
        %
        RR1 = simMat2 * RT1 * simMat3 * RT1';
        RR1 = RR1 ./ ((sum(RR1,2) * sum(RR1,1)) .^ 0.5 + 0.001);
        %
        RR2 = DR1' * simMat1 * DR1 * simMat2;
        RR2 = RR2 ./ ((sum(RR2,2) * sum(RR2,1)) .^ 0.5 + 0.001);
        %
        %DR2 = decay * D * DR1 * RR1 + (1 - decay) * drMatrix;
        %RT2 = decay * RR2 * RT1 * T + (1 - decay) * rtMatrix;

        DR2 = decay * DR1 * RR1 + (1 - decay) * transMat12;
        RT2 = decay * RR2 * RT1 + (1 - decay) * transMat23;
    end
transMat12 = DR2;
transMat23 = RT2;
fprintf('\n');
    %dtMatrix_cal = DR2 * rrMatrix * RT2;
    %save('/home/sen/Experiments/disease_target/data/dis_target_sim/dis_target_cal_sim_newNorm_allTargets_newThreeMat.txt', 'dtMatrix_cal', '-ASCII');
end
