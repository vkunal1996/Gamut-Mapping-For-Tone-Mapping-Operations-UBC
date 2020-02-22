function [ clipped, error, mean, std, Max, Min, proportion, nb, rishab,kunal ] = ...
        main_BT709_irrevesible( space,algo,in, gammut_folder, metric,s,lut )
%UNTITLED3 Summary of this function goes here
%   Clip in the wanted state with the chosen algorithm
%   Map the given input using the selected combination of color space and
%   projection technique, if given a LUT it will use the fast algorithm
    if(~exist('gammut_folder','var'))
        gammut_folder = 'C:/Users/DELL/Desktop/multimedia';
    end
    if(~exist('metric','var'))
        metric = 'DE2000';
    end

   
    in_prime = ITU_BT_1886(double(in)/(2^s-1), 1);
    if(exist('lut','var'))
        %mapping using LUT
        out=double(Ufast_mapping_ten_bits( in, lut));
        out = ITU_BT_1886(double(out)/(2^s-1), 1);
    else
       
       
       
        %in_prime = GammaTMO(double(in)/(2^s-1));%M
        inter=RGB_to_colorSpace(in_prime,space,'BT.2020','D65');
        %M : why do you go to RGB from RGB? (it is supposed that it is XYZ)
        %and why gamma encoding?
       
        switch algo
            case 'TWP'
                [inter_prime]=toward_white_point_BT709(inter,space, gammut_folder);
                out=colorSpace_to_RGB(inter_prime,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out(out<0)=0;
                out = ITU_BT_1886(out, 0);
               
%                 out(out>1)=1;
                % out(out>1)=1;
                %check below 0 and above 1
                out=round(255*out)/255;
                out(out>1)=1;
                out = ITU_BT_1886(out, 1);
                out=ConvertGamutRGB(out, 'BT.709', 'BT.2020', false);
                out=reshape(out,size(in));
                rishab=inter_prime;
                kunal=out;
               
            case 'Closest'
                [inter_prime]=closest_BT709(inter,space, gammut_folder);
                out=colorSpace_to_RGB(inter_prime,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out(out<0)=0;
%                 out(out>1)=1;
                out = ITU_BT_1886(out, 0);
                %check below 0 and above 1
                out=round(255*out)/255;
                out(out>1)=1;
                out = ITU_BT_1886(out, 1);
                out=ConvertGamutRGB(out, 'BT.709', 'BT.2020', false);
                out=reshape(out,size(in));
                rishab=inter_prime;
                kunal=out;
               
            case 'RGB_clip'
                inter3=(ConvertGamutRGB(double(in_prime), 'BT.2020', 'BT.709', false));
               
                inter3(inter3<0)=0;
                inter3(inter3>1)=1;
                inter3=round(255*inter3+0);
                %             inter3(inter3>255)=255;
                inter3=(inter3-0)/255;
                out=ConvertGamutRGB(double(inter3), 'BT.709', 'BT.2020', false);
            case 'wrong'
                %interpet the BT2020 content as being in BT709
                out=(ConvertGamutRGB(double(in_prime), 'BT.709', 'BT.2020', false));
               
                out=round(255*out)/255;
               
                clipped=out;
            case 'Mid_point'
                %For Closest Point%
               
                [inter_prime_cp]=closest_BT709(inter,space, gammut_folder);
                out_cp=colorSpace_to_RGB(inter_prime_cp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_cp(out_cp<0)=0;
                %out(out>1)=1;
                out_cp = ITU_BT_1886(out_cp, 0);
                %check below 0 and above 1
                out_cp=round(255*out_cp)/255;
                out_cp(out_cp>1)=1;
                out_cp = ITU_BT_1886(out_cp, 1);
                out_cp=ConvertGamutRGB(out_cp, 'BT.709', 'BT.2020', false);
                out_cp=reshape(out_cp,size(in));
                %rishab=inter_prime;
                %kunal=out;
               
                %For TWP Case%
                [inter_prime_twp]=toward_white_point_BT709(inter,space, gammut_folder);
                out_twp=colorSpace_to_RGB(inter_prime_twp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_twp(out_twp<0)=0;
                out_twp = ITU_BT_1886(out_twp, 0);
               
                %out(out>1)=1;
                % out(out>1)=1;
                %check below 0 and above 1
                out_twp=round(255*out_twp)/255;
                out_twp(out_twp>1)=1;
                out_twp = ITU_BT_1886(out_twp, 1);
                out_twp=ConvertGamutRGB(out_twp, 'BT.709', 'BT.2020', false);
                out_twp=reshape(out_twp,size(in));
                %rishab=inter_prime;
                %kunal=out;
                out=(out_cp+out_twp)/2;
             
            case 'Mid_point_twp'
                %For Closest Point%
                
                [inter_prime_cp]=closest_BT709(inter,space, gammut_folder);
                out_cp=colorSpace_to_RGB(inter_prime_cp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_cp(out_cp<0)=0;
                %out(out>1)=1;
                out_cp = ITU_BT_1886(out_cp, 0);
                %check below 0 and above 1
                out_cp=round(255*out_cp)/255;
                out_cp(out_cp>1)=1;
                out_cp = ITU_BT_1886(out_cp, 1);
                out_cp=ConvertGamutRGB(out_cp, 'BT.709', 'BT.2020', false);
                out_cp=reshape(out_cp,size(in));
                %rishab=inter_prime;
                %kunal=out;
                
                %For TWP Case%
                [inter_prime_twp]=toward_white_point_BT709(inter,space, gammut_folder);
                out_twp=colorSpace_to_RGB(inter_prime_twp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_twp(out_twp<0)=0;
                out_twp = ITU_BT_1886(out_twp, 0);
               
                %out(out>1)=1;
                % out(out>1)=1;
                %check below 0 and above 1
                out_twp=round(255*out_twp)/255;
                out_twp(out_twp>1)=1;
                out_twp = ITU_BT_1886(out_twp, 1);
                out_twp=ConvertGamutRGB(out_twp, 'BT.709', 'BT.2020', false);
                out_twp=reshape(out_twp,size(in));
                %rishab=inter_prime;
                %kunal=out;
                mid_point=(out_cp+out_twp)/2;
                out=(mid_point+out_twp)/2;
            
            case 'Mid_point_cp'
                %For Closest Point%
                
                [inter_prime_cp]=closest_BT709(inter,space, gammut_folder);
                out_cp=colorSpace_to_RGB(inter_prime_cp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_cp(out_cp<0)=0;
                %out(out>1)=1;
                out_cp = ITU_BT_1886(out_cp, 0);
                %check below 0 and above 1
                out_cp=round(255*out_cp)/255;
                out_cp(out_cp>1)=1;
                out_cp = ITU_BT_1886(out_cp, 1);
                out_cp=ConvertGamutRGB(out_cp, 'BT.709', 'BT.2020', false);
                out_cp=reshape(out_cp,size(in));
                %rishab=inter_prime;
                %kunal=out;
                
                %For TWP Case%
                [inter_prime_twp]=toward_white_point_BT709(inter,space, gammut_folder);
                out_twp=colorSpace_to_RGB(inter_prime_twp,space,'BT.709','D65');%,'BT.2020','BT.2020','D65');
                out_twp(out_twp<0)=0;
                out_twp = ITU_BT_1886(out_twp, 0);
               
                %out(out>1)=1;
                % out(out>1)=1;
                %check below 0 and above 1
                out_twp=round(255*out_twp)/255;
                out_twp(out_twp>1)=1;
                out_twp = ITU_BT_1886(out_twp, 1);
                out_twp=ConvertGamutRGB(out_twp, 'BT.709', 'BT.2020', false);
                out_twp=reshape(out_twp,size(in));
                %rishab=inter_prime;
                %kunal=out;
                mid_point=(out_cp+out_twp)/2;
                out=(mid_point+out_cp)/2;   
        end
    end
   
    switch metric
        case 'DE2000'
            [error,mean,std,Max,Min,proportion, nb]=compute_deltaE(in_prime,out);
    end
    clipped=uint16( ITU_BT_1886(double(out), 0)*(2^s-1));
end
