function res_angle = iterFresnel(varargin)
%IFTA Iterative Fresnel Transform Algorithm �����������㷨
%   H = iterFresnel(A, LW, LH, z, lambda, N) ��ͼ��A����N�η������������㣬���ش���λ����
%   A  - M��N�ĻҶ�ͼ����
%   LW - ͼ����ȣ���λ����
%   LH - ͼ��߶ȣ���λ����
%   z  - ����ƽ�浽�۲�ƽ����룬��λ����
%   lambda - ����Ⲩ������λ����
%   N - ��������
%
%   iterFresnel(A, LW, LH, z, lambda, N, ERR) ��ͼ��A����N�η������������㣬���ش���λ����
%   A  - M��N�ĻҶ�ͼ����
%   LW - ͼ����ȣ���λ����
%   LH - ͼ��߶ȣ���λ����
%   z  - ����ƽ�浽�۲�ƽ����룬��λ����
%   lambda - ����Ⲩ������λ����
%   ERR - �����ֵ
%
%   H - ����ȫϢͼ��λ
%
%   Author Information
%   -----------------------
%   Author : rlxu
%   Update Date : 2019-10-15
%
%   Copyright 2019 Key Laboratory of ICSP Anhui University

if nargin > 0
    [varargin{:}] = convertStringsToChars(varargin{:});
end

[data, width_Length, height_Length, z, lambda, n_iter, err] = parse_inputs(varargin{:});

if (isempty(err))
        err = 0;
end

data = double(data);
[height_Pixel, width_Pixel] = size(data);
I = data ./ max(max(data));
InitPhase = -pi + (pi + pi) * rand(height_Pixel, width_Pixel);
I1 = I .* exp(1j * InitPhase);
avg1=mean(mean(abs(I1)));

for n = 1 : 1 : n_iter
    H = propDFFT(I1, width_Length, height_Length, lambda, z);
    I2 = propDFFT(exp(1j .* angle(H)), width_Length, height_Length, lambda, -z);
    avg2=mean(mean(abs(I2)));
    I2=(I2./avg2).*avg1;
    rmse = (mean(mean((abs(I2)-abs(I)).^2)))^0.5;
    if (rmse <= err)
        break;
    end
    I1 = I .* exp(1j .* angle(I2));
end
res_angle = mod(angle(H), 2*pi);

end

% Function parse_inputs
function [data, width_Length, height_Length, z, lambda, n_iter, err] = parse_inputs(varargin)
% Initialization Parameter
data   = [];
width_Length     = 0.0;
height_Length     = 0.0;
z      = 0.0;
lambda = 0.0;
n_iter = 0;
err    = 0.0;

if (nargin < 6 || nargin > 7)
	error('����������������');
end

if (size(varargin{1}, 3) > 1)
	error('���벻�ǻҶ�ͼ��');
end

if (nargin == 6)
    data = varargin{1};
    width_Length = varargin{2};
    height_Length = varargin{3};
    z  = varargin{4};
    lambda = varargin{5};
    n_iter = int32(varargin{6});
end

if (nargin == 7)
    data = varargin{1};
    width_Length = varargin{2};
    height_Length = varargin{3};
    z  = varargin{4};
    lambda = varargin{5};
    n_iter = int32(varargin{6});
    err = varargin{7};
end

end
