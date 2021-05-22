function createCSV(header,data,savePath)
    %write header to file
    fid = fopen(savePath,'w'); 
    fprintf(fid,'%s\n',header);
    fclose(fid);
    
    %write data to end of file
    dlmwrite(savePath,data,'-append');
end

