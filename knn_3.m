clear all;clc;
load('Ang_pca.mat');load('Hap_pca.mat');load('Sur_pca.mat')

% load('Ang.mat');load('Hap.mat');load('Sur.mat')
% Ang_pca=Ang;Hap_pca=Hap;Sur_pca=Sur;



k=8;
test_num=30;
column=size(Ang_pca,2);

%%%训练数据
angry_train_data=Ang_pca(1:40,:);
happy_train_data=Hap_pca(1:40,:);
sur_train_data=Sur_pca(1:40,:);
train_data=[angry_train_data;happy_train_data;sur_train_data];
angry_sample_num=40;
happy_sample_num=40;
sur_sample_num=40;
sample_num = angry_sample_num + happy_sample_num + sur_sample_num ;

%%%训练数据的标签
train_label = zeros(sample_num,1);
train_label(1:angry_sample_num,:) = 1;      %%%angry -----1
train_label(angry_sample_num+1:80,:) = 2;   %%%happy -----2
train_label(81:end,:)=3;                    %%%sur   -----3

%%%测试数据
test_data=Ang_pca(41:50,:);                 %%%Ang
test_data(11:20,:)=Hap_pca(41:50,:);        %%%Hap
test_data(21:30,:)=Sur_pca(41:50,:);        %%%Sur
%%%测试数据打好标签
test_data(1:10,column+1)=1;               %%%% Angry作标签1
test_data(11:20,column+1)=2;              %%%% Happy作标签2
test_data(21:30,column+1)=3;              %%%% Surprise作标签3


%%%
distance=zeros(test_num,sample_num);

right = 0;
wrong = 0;
for i=1:test_num
   for j=1:sample_num 
       distance(i,j) = sqrt(sum((test_data(i,1:column) - train_data(j,:)).^2));
   end
    
   angry_count  = 0;
   happy_count  = 0;
   surprise_count =0;
   
   for j = 1:k
      [value,index] = min(distance(i,:));
      distance(i,index) = NaN;
      gender = train_label(index);
       switch(gender)
           case 1
               angry_count = angry_count + 1;
           case 2
               happy_count = happy_count +1;
           otherwise
               surprise_count = surprise_count + 1;
       end   
   end
% % % % % % % %   改动从下面开始
    all_class = [angry_count,happy_count,surprise_count]; %%%将三类数据计算存到矩阵中
    [max_num,max_index]=max(all_class);   %%%%计算三类中出现次数最多的
    
    if max_index == 1
        fprintf('angry\n');
        if test_data(i,column+1) == 1
            right = right +1;
        else
            wrong = wrong +1 ;
        end
    else if  max_index == 2
            fprintf('happy\n');
            if test_data(i,column+1) == 2
                right = right +1 ;
            else
                wrong = wrong + 1;
            end
        else
            fprintf('surprise\n');
            if test_data(i,column+1) == 3
                right = right +1;
            else
                wrong = wrong +1 ;
            end
        end    
    end
                                  

end
accauary = right/(right+wrong);
fprintf('right=%d\nwrong=%d\naccauary=%g',right, wrong, accauary);
