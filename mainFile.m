%set the paths
    clear all;
    curent_folder=mfilename('fullpath');
    cd(curent_folder(1:end-length(mfilename)));
    addpath(genpath(pwd))
 
    metrics={'DE2000'};
    curent_folder=mfilename('fullpath');
    cd(curent_folder(1:end-length(mfilename)));
    % cd ./..
    gammut_folder=[pwd,'\triangles\','BT709'];
    addpath(genpath(pwd));
    file_position=pwd;
    Gammut_array={'BT2020', 'BT709', 'BT4981'};
    Spaces_array={'Yxy','YUV','YUVp','Luv','Lab','ICaCb'};
    Algorithm_array={'TWP','Closest','RGB_clip','wrong','CP_C','CP_C_fast','Mid_point','Mid_point_twp','Mid_point_cp'};%,'Closest_3D'
    T=table;
    sum_all = 0;
    %lut = zeros()
 
    for j=9:9%2%length(Algorithm_array):length(Algorithm_array)
        for k=5:5%1:6%length(Spaces_array)
            fprintf([cell2mat(Algorithm_array(j)), cell2mat(Spaces_array(k)), '\n'])
            mean2=0;nb2=0;std2=0;time2=0;
            start=tic;
            Max=0;
            Min=0;
            nb2=[];mean2=[];std2=[];
            %if 10 bit we need to split the input array because 2^30 bit is too
            %big to compute in one time so we devide and store in the result in
            %variable "clipped2"
    %            clipped2=zeros(2^30,3,'uint16');
    %             lut2 = importdata([curent_folder,'\LUT\','clipped_',Spaces_array{k},'_', Algorithm_array{j},'.mat']);
    %             lut=struct2cell (lut2);
    %             lut=lut{1};
    %             clear lut2;
%image22=imread('adobeRGB.jpg');
            sum_lessThan1 = 0;  
            for s=51:75
                s
                %%All combiantions in 8 bits
 
                %All combinations in 10 bits which had to be devide
                %in part here 128 and we do it part per part
                in=all_colors_array_10bit(s,128,1);
                N_bit=10;
 
                [clipped,  error, mean1, std1, Max1, Min1, proportion, nb]=...
                    main_BT709_irrevesible_2(...
                    cell2mat(Spaces_array(k)), cell2mat(Algorithm_array(j)),...
                    in,gammut_folder, 'DE2000',N_bit);
                %if 10 bits
                %clipped2(2^23*(s-1)+1:2^23*s,:)=reshape(clipped,2^23,3);
                 clipped2(1:2^23*1,:)=reshape(clipped,2^23,3);
                clipped2=double(clipped2);
                if ~nb
                    mean1=0;std1=0;Max=0;Min=1000;
                end
                nb2=[nb2,nb];mean2=[mean2,mean1];std2=[std2,std1];
                sum_lessThan1 = size(error(error<1),1) + sum_lessThan1;
                Max =max(Max1,Max);
                Min = min(Min1,Min);
               % image22=imread('adobeRGB.jpg');
                %image223(2^23*(s-1)+1:1365*2048,:)=reshape(image22,1365*2048,3);
                %concatinating inputs and error values
 
               % error2(2^23*(s-1)+1:2^23*s,:)=reshape(error,[2^23,1]);
                  error2(1:2^23*1,:)=reshape(error,[2^23,1]);
                 
 
               % in2(2^23*(s-1)+1:2^23*s,:)=reshape(in,2^23,3);
                in2(1:2^23*1,:)=reshape(in,2^23,3);
                in2 = double(in2);
                lut = [clipped2,error2];
                lut = double(lut);
                finalTable=[in2,lut];
                finalTable = double(finalTable);
        fname = sprintf('_%d', s);
        save(['E:\Matlab Project\_FromMaryam\MidPointLut_E','\','MidPointLutcp_E',fname,'.mat'],'finalTable');
        %save(['E:\_Multimedia\_FromMaryam\_output','\','ClosestPointlut',fname,'.mat'],'finalTable');
        %save(['E:\_Multimedia\_FromMaryam\_output','\','inClosestPoint',fname,'.mat'],'finalTable');
       %  save(['C:\Users\DELL\Desktop\multimedia201','\','ClosestPointlut',fname,'.mat'],'finalTable');
       % save(['C:\Users\DELL\Desktop\multimedia201','\','inClosestPoint vb',fname,'.mat'],'finalTable');
        %TO clear the memory
       
        %clear error;
        %clear error2;
        %clear in2;
        %clear lut;
        %clear finalTable;
        %error = [];
        %error2 = [];
        in2 = [];
        lut = [];
      %  finalTable = [];
       
        %save('E:\Matlab Project\_FromMaryam\MidPointLut_E','lut');
        %save('C:\Users\DELL\Desktop\multimedia201\Image.mat','image223');
            end
 %rishab;
 %rishab2(1:256*32768,:)=reshape(rishab,[256*32768,3]);
 
% kunal;
% kunal2(1:256*32768,:)=reshape(kunal,[256*32768,3]);
            time=toc(start);
 
%in2(1:256*3276823,:)=reshape(in,[256*3276823,3]);
            %if 10 bits
            mean3=(mean2.*nb2)/sum(nb2(:));
            nb3=sum(nb2(:));%+nb;std2=std2+std1*nb;
 
            time2=time2+time;
 
            %store the clipped result which will be used as LUT
            dun=0;
 
            save([file_position,'\','clipped_',cell2mat(Spaces_array(k)),'_',cell2mat(Algorithm_array(j)),'.mat'],'clipped2','dun','-v7.3');
            percentage = 0;
            T=write_results(percentage, mean3, sum_lessThan1,Max, Min, nb3/2^30, nb3,...
                         'all color 10 bit',Spaces_array(k),Algorithm_array(j),metrics(1),time2,T);
        end
    end
 
%function result = fetchtable()
 
% This function will fetch the values from the LUT
%S=load('clipped_Lab_TWP.mat');
%temp=S.clipped2(3:3,1:3);
%disp(S.clipped2(1:10,1:3));
%disp(temp(1));
%disp(temp(2));
%disp(temp(3));
 
%end
writetable(T,[file_position,'\results', cell2mat(Gammut_array(2)),num2str(clock),'ALL.xlsx']);