function data_struct=tarquin_read_fitcsv(pathc_output_fit)
% Jeff Stout MIT 20170523
% Reads in a output_fit.csv file from Tarquin.
% Output is a structure of length N_voxels
% data_struct.location is [Row,Col,Slice]
% data_struct.desc is a cell array of data descriptions
% data_struct.data is a column-wise array of the data.

% %% to use while writing this function
% pathc_output_fit='/home2/jstout/Data/Cardiac/Spectroscopy/C004/output_fit.csv'
% slice=4
% row=8
% col=8

% load data
fid=fopen(pathc_output_fit,'r');
data=textscan(fid,'%s','delimiter','\n');
fclose(fid);
N_lines=length(data{1});

vox_n=0;
data_row=0;
data_struct=struct;
for i=1:N_lines % go through each line
    line=data{1}{i};
    if ~isempty(strfind(line,'Row'))
        vox_n=vox_n+1;
        data_row=1;
        R=strfind(line,'Row');
        C=strfind(line,'Col');
        S=strfind(line,'Slice');
        data_struct(vox_n).location=...
            [str2num(line(R+6:C-1)),str2num(line(C+6:S-1)),str2num(line(S+8:end))];
    elseif ~isempty(strfind(line,'PPMScale'))
        desc_temp=textscan(line,'%s','delimiter',',');
        data_struct(vox_n).desc=desc_temp{1};
    else 
        data_temp=textscan(line,'%f','delimiter',',');
        data_struct(vox_n).data(data_row,:)=data_temp{1}';
        data_row=data_row+1;
    end
end
    
end