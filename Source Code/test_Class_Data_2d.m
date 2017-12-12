%   test_Clss_DATA_2D : A script of testing methods and propeties in Class.
%
%   Copyright 2017 Wenjie Liao
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
 
clc;clear
%-------------------------------------------------------------------------%
x  = sort(randn([10,1]));
y1 = randn([10,1]);
y2 = randn([1,10]);
y3 = randn([1,20]);
y4 = randn([2,10]);
y5 = randn([10,2]);
y6 = randn([3,4]);
y7 = randn([10,1,1]);
% y8 = randn([10,1,2]).';



data_test1 = Data_2d(x, y1);
data_test2 = Data_2d(x, y2);
% data_test3 = Data_2d(x, y3)
% data_test4 = Data_2d(x, y4)
% data_test5 = Data_2d(x, y5)
% data_test6 = Data_2d(x, y6)
data_test7 = Data_2d(x, y7);
% data_test8 = Data_2d(x, y8)

%-------------------------------------------------------------------------%

flag1x = (data_test1.get_xaxis == x)
flag2x = (data_test2.get_xaxis == x)
flag7x = (data_test7.get_xaxis == x)
flag1y = (data_test1.get_yaxis == y1)
flag2y = (data_test2.get_yaxis == y2.')
flag7y = (data_test1.get_yaxis == y7)

new_x = sort(randn([1,11]));
data_test1 = set_xaxis(data_test1, new_x);
flag1x = (data_test1.get_xaxis == new_x.')
x_name = 'xlabel';
data_test1 = set_xlabel(data_test1, x_name);

%-------------------------------------------------------------------------%
A = 'xlable';
B = "ylable";
C = 'xlabel ylabel';
D = "xlabel ylabel";
E = {'xlable' 'ylable'};
F = {"xlabel" "ylabel"};
G = 2134123;
H = 123912.123123;
data_test1 = data_test1.set_xlabel(A);
data_test1 = set_xlabel(data_test1, B);
data_test1 = set_xlabel(data_test1, C);
data_test1 = set_xlabel(data_test1, D);
% data_test1 = set_xlabel(data_test1, E);
% data_test1 = set_xlabel(data_test1, F);
% data_test1 = set_xlabel(data_test1, G);
% data_test1 = set_xlabel(data_test1, H);
data_test1 = data_test1.set_ylabel(A);
data_test1 = set_ylabel(data_test1, B);
data_test1 = set_ylabel(data_test1, C);
data_test1 = set_ylabel(data_test1, D);
% data_test1 = set_ylabel(data_test1, E);
% data_test1 = set_ylabel(data_test1, F);
% data_test1 = set_ylabel(data_test1, G);
% data_test1 = set_ylabel(data_test1, H);
data_test1 = data_test1.set_xunits(A);
data_test1 = set_xunits(data_test1, B);
data_test1 = set_xunits(data_test1, C);
data_test1 = set_xunits(data_test1, D);
% data_test1 = set_xunits(data_test1, E);
% data_test1 = set_xunits(data_test1, F);
% data_test1 = set_xunits(data_test1, G);
% data_test1 = set_yunits(data_test1, H);
data_test1 = data_test1.set_yunits(A);
data_test1 = set_yunits(data_test1, B);
data_test1 = set_yunits(data_test1, C);
data_test1 = set_yunits(data_test1, D);
% data_test1 = set_yunits(data_test1, E);
% data_test1 = set_yunits(data_test1, F);
% data_test1 = set_yunits(data_test1, G);
% data_test1 = set_yunits(data_test1, H);

%-------------------------------------------------------------------------%
data_test1.get_xaxis
data_test1.get_yaxis
data_test1.get_xlabel
data_test1.get_ylabel
data_test1.get_xunits
data_test1.get_yunits
data_test1.get_1orderDerivative
data_test1.get_2orderDerivative
data_test1.get_integration
%-------------------------------------------------------------------------%




