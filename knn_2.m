clear all;clc;

load('Ang_pca.mat');load('Hap_pca.mat')

k=7;
test_num=20;

%%%训练数据
angry_train_data=Ang_pca(1:40,:);
happy_train_data=Hap_pca(1:40,:);
train_data=[angry_train_data;happy_train_data];
angry_sample_num=40;
happy_sample_num=40;
sample_num = angry_sample_num + happy_sample_num ;

%%%训练数据的标签
train_label = zeros(sample_num,1);
train_label(1:angry_sample_num,:) = 1;
train_label(angry_sample_num+1:end,:) = 0;

%%%测试数据
test_data=Ang_pca(41:50,:);
test_data(11:20,:)=Hap_pca(41:50,:);
%%%测试数据打好标签
test_data(1:10,36)=1;
test_data(11:20,36)=0;  

%%%
distance=zeros(test_num,sample_num);

right = 0;
wrong = 0;
for i=1:test_num
   for j=1:sample_num 
       distance(i,j) = sqrt(sum((test_data(i,1:35) - train_data(j,:)).^2));
   end
    
   angry_count  = 0;
   happy_count  = 0;
   
   for j = 1:k
      [value,index] = min(distance(i,:));
      distance(i,index) = NaN;
      gender = train_label(index);
      if(gender == 1)
          angry_count = angry_count + 1;
      else
          happy_count = happy_count + 1;
      end
   end
   
   if(angry_count > happy_count)
       fprintf('angry\n');
       if test_data(i,36) == 1
           right = right+1;
       else 
           wrong = wrong + 1;
       end
   else
       fprintf('happy\n');
       if test_data(i,36) == 0
           right = right + 1;
       else
           wrong = wrong + 1;
       end
   end

end
accauary = right/(right+wrong);
fprintf('right=%d\nwrong=%d\naccauary=%g',right, wrong, accauary);
