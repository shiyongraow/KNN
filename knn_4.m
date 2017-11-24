clear all;clc;
%%%���ؽ�ά�����������    ���ݸ�ʽҪһ��  
load('Ang_pca.mat');load('Hap_pca.mat');load('Sur_pca.mat');load('Sad_pca.mat')

%%%��άǰ  
% load('Ang.mat');load('Hap.mat');load('Sur.mat');load('Sad.mat')
% Ang_pca = Ang; Hap_pca = Hap; Sur_pca = Sur; Sad_pca = Sad;

k=7;  %%%�趨k�ķ�Χ     
%%%%%%%%%%%%%%%%%%%%
%   k=7   ��ά     25/40=62.5%
%   k=8   δ��ά   29/40=72.5%
%%%%%%%%%%%%%%%%%%%%
  
test_num=40;  %%%%������������
column=size(Ang_pca,2);   %%%%���ݵ���

%%%ѵ������
ang_data=Ang_pca(1:40,:);
hap_data=Hap_pca(1:40,:);
sur_data=Sur_pca(1:40,:);
sad_data=Sad_pca(1:40,:);    %%%%ȡÿ��������ǰ40��

%%%%�ϳ��ܵ�ѵ������
train_data=[ang_data;hap_data;sur_data;sad_data];
% sample_num = size(train_data,1);  %%%%�ܵ�ѵ��������
ang_sample_num=size(ang_data,1);hap_sample_num=size(hap_data,1);
sur_sample_num=size(sur_data,1);sad_sample_num=size(sad_data,1);
sample_num = ang_sample_num + hap_sample_num + sur_sample_num + sad_sample_num ;

%%%ѵ�����ݵı�ǩ
train_label = zeros(sample_num,1);
train_label(1:ang_sample_num,:) = 1;                                                                        %%%ang -----1
train_label(ang_sample_num+1:ang_sample_num + hap_sample_num,:) = 2;                                        %%%hap -----2
train_label(ang_sample_num + hap_sample_num + 1:ang_sample_num + hap_sample_num + sur_sample_num,:)=3;      %%%sur -----3
train_label(ang_sample_num + hap_sample_num + sur_sample_num + 1:end,:)=4;                                  %%%sad -----4


%%%��������
test_data=Ang_pca(41:end,:);                 %%%Ang
test_data(11:20,:)=Hap_pca(41:end,:);        %%%Hap
test_data(21:30,:)=Sur_pca(41:end,:);        %%%Sur
test_data(31:40,:)=Sad_pca(41:end,:);        %%%Sad
%%%�������ݴ�ñ�ǩ
test_data(1:10,column+1)=1;               %%%% Angry����ǩ1
test_data(11:20,column+1)=2;              %%%% Happy����ǩ2
test_data(21:30,column+1)=3;              %%%% Surprise����ǩ3
test_data(31:40,column+1)=4;              %%%% Sad����ǩ4


%%%
distance=zeros(test_num,sample_num);

right = 0;
wrong = 0;
for i = 1: test_num
    for j = 1: sample_num
         distance(i,j) =sqrt(sum((test_data(i,1:column) - train_data(j,:)).^2));  %%%ŷ�Ͼ���
%         distance(i,j) = sum(abs(test_data(i,1:column) - train_data(j,:)));       %%%�����پ���
%         distance(i,j) =  max(abs(test_data(i,1:column) - train_data(j,:)));        %%%�б�ѩ�����
    end
    
    angry_count = 0;      %%%%����
    happy_count = 0;
    surprise_count = 0;
    sad_count = 0;
    
    for j = 1 : k         %%%% ��K��Χ��Ѱ��
    [value,index] = min(distance(i,:));
    distance(i,index) = NaN;
    gender = train_label(index);   %%%�ҵ���Сλ��   ��ȡ��ǩ
    
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

all_class = [angry_count,happy_count,surprise_count,sad_count]; %%%%�����ֵ�������Ŀ�洢��������
[max_num,max_index] = max(all_class);  %%%���������г��ִ���������һ��

    if max_index == 1               %%%�� angry�������
        fprintf('angry\n');
        if test_data(i,column+1) == 1     %%%%����
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
accauary = right/(right+wrong);   %%%%����ʶ����
fprintf('right=%d\nwrong=%d\naccauary=%g',right, wrong, accauary);
