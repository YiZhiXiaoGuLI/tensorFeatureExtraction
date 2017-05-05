function [ Xtrain, Xvarid, Xtest, ytrain, yvarid, ytest ] = prepareMNIST( d, Ntrain, Nvarid, Ntest, classmap, varargin )
% MNIST���擾���A�O�������{���B
% ���� : 
%   d : double�̐���. �C���[�W�̃s�N�Z�����B���̃s�N�Z����28^2��菬�����Ƃ��͉摜�����k����Bsqrt(28^2 / d)�͐����łȂ���΂Ȃ�Ȃ��B
%   Ntrain : double�̐���. �P���f�[�^�� (<= 60000)
%   Nvarid : double�̐���. varidation�f�[�^�� (<= 60000)
%   Ntest : double�̐���. �e�X�g�f�[�^�� (<= 10000)
%   classmap : containers.Map. �N���X0,1,2, ...��1,2,3,...,10�ɕύX����B
%   varargin (optional) : �����P�̉ϒ������Bchar. �摜���k�̃��\�b�h�B�f�t�H���g�ł�nearest
% �o�� : 
%   Xtrain : Ntrain * d��double�̍s��B 
%   Xvarid : Nvarid * d��double�̍s��B 
%   Xtest : Ntest * d��double�̍s��B 
%   ytrain : Ntrain * 1��double�̍s��B
%   yvarid :Nvarid * 1��double�̍s��B
%   ytest : Ntest * 1��double�̍s��B

IsInteger = @(x) (abs(round(x)-x)) <= eps('double');
if  Ntrain + Nvarid > 60000 || Ntest > 10000
    error('ArgCheck:ArgRangeError', '�f�[�^���̎w�肪�Ԉ���Ă��܂��B');
end

if ~IsInteger( sqrt(28^2/d) ) ||  d <= 0 || d > 28^2
    error('ArgCheck:dValueError', 'sqrt( 28^2 / d )�͐����łȂ���΂����܂���B');
end

if length(varargin) == 0
    method = 'nearest';
elseif length(varargin) == 1
    method = varargin{1} ;
else
    error('ArgCheck:VararginError', '�ϒ��������������܂��B');
end

[XtrainPlusVarid, yTrainPlusVaridRaw, Xtest, yTestRaw] = setupMnist('binary', false,'keepSparse', false);
XtrainPlusVarid = XtrainPlusVarid(1:Ntrain + Nvarid, :);
yTrainPlusVaridRaw = yTrainPlusVaridRaw(1:Ntrain + Nvarid, :);
Xtest = Xtest(1:Ntest, :);
yTestRaw = yTestRaw(1:Ntest, :);

yTrainPlusVarid = zeros(Ntrain + Nvarid, 1);
for n = 1:Ntrain + Nvarid
    yTrainPlusVarid(n) = classmap(yTrainPlusVaridRaw(n));
end
ytest = zeros(Ntest, 1);
for n = 1:Ntest
    ytest(n) = classmap(yTestRaw(n));
end

order1 = randperm(size(yTrainPlusVarid,1));
XtrainPlusVaridRand = XtrainPlusVarid(order1, :); 
yTrainPlusVaridRand = yTrainPlusVarid(order1, :);
Xtrain = XtrainPlusVaridRand(1:Ntrain,:);
Xvarid = XtrainPlusVaridRand(Ntrain+1:end, :);
ytrain = yTrainPlusVaridRand(1:Ntrain, :);
yvarid = yTrainPlusVaridRand(Ntrain+1:end, :);
order2 = randperm(size(ytest,1));
Xtest = Xtest(order2, :);
ytest = ytest(order2, :);



cprRate = 1 / sqrt(28^2 / d);
if cprRate ~= 1
    XtrainSmall = zeros(Ntrain, d);
    XvaridSmall = zeros(Nvarid, d);
    XtestSmall = zeros(Ntest, d);
    for n = 1:Ntrain
        x = Xtrain(n, :);
        x = reshape(x, [28 28]);
        xsmall = imresize(x, cprRate, method);
        xsmall = reshape(xsmall, [1 d]);
        XtrainSmall(n, :) = xsmall;
    end
    for n = 1:Nvarid
        x = Xvarid(n, :);
        x = reshape(x, [28 28]);
        xsmall = imresize(x, cprRate, method);
        xsmall = reshape(xsmall, [1 d]);
        XvaridSmall(n, :) = xsmall;
    end
    for n = 1:Ntest
        x = Xtest(n, :);
        x = reshape(x, [28 28]);
        xsmall = imresize(x, cprRate, method);
        xsmall = reshape(xsmall, [1 d]);
        XtestSmall(n, :) = xsmall;
    end
    Xtrain = XtrainSmall;
    Xvarid = XvaridSmall;
    Xtest = XtestSmall;
end

Xtrain = Xtrain / 255;
Xvarid = Xvarid / 255;
Xtest = Xtest / 255;
end