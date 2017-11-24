clear all;clc;
%%%加载降维后的四类数据    数据格式要一样  
load('Ang_pca.mat');load('Hap_pca.mat');load('Sur_pca.mat');load('Sad_pca.mat')

%%%降维前  
% load('Ang.mat');load('Hap.mat');load('Sur.mat');load('Sad.mat')
% Ang_pca = Ang; Hap_pca = Hap; Sur_pca = Sur; Sad_pca = Sad;

k=7;  %%%设定k的范围     
%%%%%%%%%%%%%%%%%%%%
%   k=7   降维     25/40=62.5%
%   k=8   未降维   29/40=72.5%
%%%%%%%%%%%%%%%%%%%%
  
test_num=40;  %%%%测试样本数量
column=size(Ang_pca,2);   %%%%数据的列

%%%训练数据
ang_data=Ang_pca(1:40,:);
hap_data=Hap_pca(1:40,:);
sur_data=Sur_pca(1:40,:);
sad_data=Sad_pca(1:40,:);    %%%%取每类样本的前40个

%%%%合成总的训练数据
train_data=[ang_data;hap_data;sur_data;sad_data];
% sample_num = size(train_data,1);  %%%%总的训练样本数
ang_sample_num=size(ang_data,1);hap_sample_num=size(hap_data,1);
sur_sample_num=size(sur_data,1);sad_sample_num=size(sad_data,1);
sample_num = ang_sample_num + hap_sample_num + sur_sample_num + sad_sample_num ;

%%%训练数据的标签
train_label = zeros(sample_num,1);
train_label(1:ang_sample_num,:) = 1;                                                                        %%%ang -----1
train_label(ang_sample_num+1:ang_sample_num + hap_sample_num,:) = 2;                                        %%%hap -----2
train_label(ang_sample_num + hap_sample_num + 1:ang_sample_num + hap_sample_num + sur_sample_num,:)=3;      %%%sur -----3
train_label(ang_sample_num + hap_sample_num + sur_sample_num + 1:end,:)=4;                                  %%%sad -----4


%%%测试数据
test_data=Ang_pca(41:end,:);                 %%%Ang
test_data(11:20,:)=Hap_pca(41:end,:);        %%%Hap
test_data(21:30,:)=Sur_pca(41:end,:);        %%%Sur
test_data(31:40,:)=Sad_pca(41:end,:);        %%%Sad
%%%测试数据打好标签
test_data(1:10,column+1)=1;               %%%% Angry作标签1
test_data(11:20,column+1)=2;              %%%% Happy作标签2
test_data(21:30,column+1)=3;              %%%% Surprise作标签3
test_data(31:40,column+1)=4;              %%%% Sad作标签4


%%%
distance=zeros(test_num,sample_num);

right = 0;
wrong = 0;
for i = 1: test_num
    for j = 1: sample_num
         distance(i,j) =sqrt(sum((test_data(i,1:column) - train_data(j,:)).^2));  %%%欧氏距离
%         distance(i,j) = sum(abs(test_data(i,1:column) - train_data(j,:)));       %%%曼哈顿距离
%         distance(i,j) =  max(abs(test_data(i,1:column) - train_data(j,:)));        %%%切比雪夫距离
    end
    
    angry_count = 0;      %%%%计数
    happy_count = 0;
    surprise_count = 0;
    sad_count = 0;
    
    for j = 1 : k         %%%% 在K范围内寻找
    [value,index] = min(distance(i,:));
    distance(i,index) = NaN;
    gender = train_label(index);   %%%找到最小位置   获取标签
    
        switch(gender)
            case 1
                angry_count =angry_count + 1;
            case 2
                happy_count = happy_count + 1;
            case 3
                surprise_count = surprise_count + 1;
            otherwise
                sad_count = sad_count + 1;
        end 
    end

all_class = [angry_count,happy_count,surprise_count,sad_count]; %%%%将出现的四类数目存储到矩阵中
[max_num,max_index] = max(all_class);  %%%计算四类中出现次数最多的那一类

    if max_index == 1               %%%即 angry出现最多
        fprintf('angry\n');
        if test_data(i,column+1) == 1     %%%%检验
            right = right +1;     
        else
            wrong = wrong + 1;
        end
    else if max_index == 2
            fprintf('happy\n');
            if test_data(i,column+1) == 2
                right = right + 1;
            else
                wrong = wrong + 1;
            end 
        else if max_index == 3
                fprintf('surprise\n');
                if test_data(i,column+1) == 3
                    right = right + 1;
                else
                    wrong = wrong + 1;
                end
            else
                fprintf('sad\n');
                if test_data(i,column+1) == 4
                    right = right + 1;
                else
                    wrong = wrong + 1;
                end
            end
        end
    
    end

end
accauary = right/(right+wrong);   %%%%计算识别率
fprintf('right=%d\nwrong=%d\naccauary=%g',right, wrong, accauary);
