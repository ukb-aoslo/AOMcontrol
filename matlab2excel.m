%-------------------------------------------------------------------------------
% Matlab2Excel (v.1.0b) - 2D data table write access utility
%----------------------------[ ALEX 2004 (c) UCB SO ]---------------------------
%
%USAGE: 
% 1. >> exist = matlab2excel('open' ,'full_file_path_and_name');
%      to open new or existing excel data file and initialize the utility
%      to work within this file.
%      Must be the firstmost call to the utility prior to any table access command.
%      Omit the second parameter to invoke File Select dialog window
%      and browse for the file manually.
%
%    Return integer = 1 if the new file was created; = 0 if the file exists.
%      or stop program execution on error exception.
%
%    NOTE: The first datasheet is selected for output by default
%
% 2. >> sheetnum = matlab2excel('sheet' , sheetnum);
%      to open or create particular data sheet of excel workbook [1..N].
%      Could be called anytime after the open command.
%      Will search for the last header data here.
%
%    Returns number equal to requested data sheet number if no error, 
%      or stop program execution on error exception.
%
%    NOTE: If the sheet number created is larger 
%      than initial number of data sheets in the worksheet -
%      the appropriate number of datasheets will be inserted in between.
%
% 3. >> sectionnum = matlab2excel('section' , 'section name');
%          OR
%    >> sectionnum = matlab2excel('section' , section_number);
%      to open or create particular data section in excel worksheet.
%      Could be called anytime after the open command.
%      Will search for the section by name or number if found append the following data to it.
%      If not - a new section will be created at the end
%
%    Returns number equal to requested data section number if no error, 
%      or stop program execution on error exception.
%
% 4. >> status = matlab2excel('header', cellArrayMarkersVector, 'data', cellArrayValuesVector);
%      to add a new record to current data section of current data sheet.
%      If the header is different from acquired at Open/Sheet stages -
%      the new section of data will be started on the same the data sheet.
%    NOTE
%      the header will be compared against the list of existing headers and 
%      if match one of them will add the new data to that particular section.
%      if no match found the new section will be created.
%
%------------------------------------------------------------------------------
function res = matlab2excel(varargin)

persistent fname; %excel file name
persistent pname; %path string
persistent sheetnum;
persistent newfile; %flag rized when the new empty file was created
persistent appendposition; %row number where to start adding new data
persistent currentheader; %cell array header to compare for 'the new section start' condition
persistent newsecname; %name of the section to work with
res = 0;
Excel = [];

try
    
    if (nargin<1) | (nargin>4)
        help matlab2excel;
        res = 0;
        error('Wrong number of parameters');
        return;
    end
    % ------------------------------------------------------------------------------------------------------       
    %open file by name or with dialog
    if strcmp(varargin{1},'open')
        res = [];
        sheetnum = 1;
        appendposition = 1;
        currentheader = [];
        newsecname = [];
        
        if nargin==2 & ischar(varargin{2}); %file name is provided
            fname = varargin{2};
            pname = '';
        else
            [fname,pname] = uigetfile('*.xls','Select datasheet');
        end
        
        if isempty(fname) error('No excel file specified'); end

        %testing file for existence
        path = [pname fname];
        Excel  = actxserver('excel.application'); %Excel app
        try
            newfile = 1;
            Workbook = invoke(Excel.Workbooks,'Open',path);
            newfile = 0; %never get here if there is no such file
        catch
            if newfile==1
                %No such file, creating new one
                Workbook = invoke(Excel.Workbooks,'Add');
                invoke(Workbook,'SaveAs', path);
                Workbook.Saved = 1;
            end
        end
        %seeking to the last section of file by default
        ws = get(Workbook.Worksheets,'Item',1);
        [appendposition, currentheader,eod,sec] = SeekToLastRow(ws,0);
        
        res = newfile; %is there a new file was just created?   
        
% ------------------------------------------------------------------------------------------------------            
    elseif strcmp(varargin{1},'sheet')
        res = 0;
        if isempty(fname)
            help Matlab2Excel;
            error('Engine not initialized. Use ''open'' option first'); 
        end
        
        if ~isnumeric(varargin{2})
            error('Only numeric sheet number [1..N] is valid for datasheet addressing.'); 
        end
        
        appendposition = 1;
        currentheader = [];
        newsecname = [];
        sheetnum = varargin{2};
        
        %testing
        path = [pname fname];
        Excel  = actxserver('excel.application'); %Excel app
        Workbook = invoke(Excel.Workbooks,'Open',path);
        found = 1;
        if isempty(Workbook)
            found=0; %no sheets at all (rare)
        else
            n = get(Workbook.Worksheets,'Count');
            if (sheetnum > n) | (sheetnum < 0) %no such sheet
                found=0;                
            end                
        end
        
        if found==0 %creating new set
            m = double(n);
            wts = Workbook.Worksheets;
            for i=m:sheetnum-1
                sl = get(wts, 'Item',i);
                sl.Select;
                invoke(Workbook.Worksheets,'Add');
                invoke(Workbook, 'Save');
                sn = get(wts, 'Item',i+1);
                sl = get(wts, 'Item',i);
                %sn.Select;
                invoke(sn,'Move',sl);
                invoke(Workbook, 'Save');
            end
            sl = get(wts, 'Item',sheetnum);
            sl.Select;
            invoke(Workbook, 'Save');
            Workbook.Saved = 1;
        else
            %seeking to the last section of file by default
            ws = get(Workbook.Worksheets,'Item',1);
            [appendposition, currentheader, eod, sec] = SeekToLastRow(ws,0);
        end
        res = sheetnum;
        
% ------------------------------------------------------------------------------------------------------            
    elseif strcmp(varargin{1},'section')
        if isempty(fname)
            help Matlab2Excel;
            res = 0;
            error('Engine not initialized. Use ''open'' option first'); 
        end 
        
        %testing
        path = [pname fname];
        Excel  = actxserver('excel.application'); %Excel app
        Workbook = invoke(Excel.Workbooks,'Open',path);
        wksheet = get(Workbook.Worksheets,'Item',sheetnum);
        
        newsecname      = [];
        secnum          = 0;
        appendposition  = 0;
        
        if ~isnumeric(varargin{2}) % literal section name given
            newsecname = varargin{2};
            
            pos0  = 1;
            found = 0;
            for secnum=1:1000 %up to 1000 sections
                [epos, head,eod,secname] = SeekToLastRow(wksheet,pos0);
                if ArraysAreEqual(newsecname, secname)
                    found=1;
                    break;
                end
                pos0 = epos+1;
                if eod==1 break; end %stop on end of files
            end
            if found==1 
                newsecname=[]; 
            end
                
            appendposition = epos;
            
        else %the numeric section number was given
            secnum0  = varargin{2};
            pos0=1;

            for secnum=1:secnum0 %up to 1000 sections
                [epos, head,eod,section] = SeekToLastRow(wksheet,pos0);
                pos0 = epos;
                if eod==1 break; end %stop on end of files
            end
            
            appendposition = epos;
        end

        res = secnum+1;
% ------------------------------------------------------------------------------------------------------        
    elseif nargin==4 %add data command
        if ( ~strcmp(varargin{1},'header') | ~strcmp(varargin{3},'data') )
            error(['Wrong command ' varargin{1}]);
        end
        
        if isempty(fname)
            help Matlab2Excel;
            res = 0;
            error('Engine not initialized. Use Open option first');
            return;
        end     
        
        %opening
        path    = [pname fname];
        Excel   = actxserver('excel.application'); %Excel app
        Workbook= invoke(Excel.Workbooks,'Open',path);
        wksheet = get(Workbook.Worksheets,'Item',sheetnum);
        
        if ArraysAreEqual(varargin{2}, currentheader)
            newheader = 0;
        else
            
            pos0  = 1;
            found = 0;
            for secnum=1:1000 %up to 1000 sections
                [epos, head,eod, sec] = SeekToLastRow(wksheet,pos0);
                if ArraysAreEqual(head,varargin{2})
                    found=1;
                    break;
                end
                
                %no more than one empty row between sections
                %just to avoid wrong sections number counting do check
                if isempty(head) secnum=secnum-1; end 
                
                pos0 = epos+1;
                if eod==1 break; end %stop on end of files
            end
            
            if found==0
                newheader = 1;
            else
                newheader = 0;
            end
            appendposition = epos;
            currentheader = head;
        end

        rightmost = size(varargin{2},2);
        
        if newheader==0 %section header match the submitted data one
            r = get(wksheet, 'rows', appendposition);
            z = invoke(r, 'Insert');
            r = get(wksheet, 'Range', eR(appendposition,1,appendposition, rightmost));
            arrout = eConvert(varargin{4});
            r.formula = arrout; %varargin{4};
            appendposition = appendposition+1;
        else %forming a new header
            currentheader = varargin{2};
            if appendposition>1 %not the first string which has no section name
                appendposition = appendposition+1;
                               
                r = get(wksheet, 'Cells', appendposition,1);
                if isempty(newsecname) %set only on section user command otherwise [] and generated here
                    cursecname = ['Section' int2str(secnum+1)];
                else
                    cursecname = newsecname;
                    newsecname = []; %reset it
                end
                r.formula = cursecname;
                appendposition=appendposition+1;
            end
            %header
            r = get(wksheet, 'Range', eR(appendposition,1,appendposition, rightmost));
            r.formula = currentheader;
            
            %data
            appendposition=appendposition+1;
            r = get(wksheet, 'Range', eR(appendposition,1,appendposition, rightmost));
            
            arrout = eConvert(varargin{4});
            
            r.value = arrout; %varargin{4};
            
            appendposition = appendposition + 1;
            
        end
        %invoke(Workbook, 'SaveAs', path, 1);
        invoke(Workbook, 'Save');
        Workbook.Saved = 1;
        invoke(Workbook, 'Close');
        res = 1;
    end %IF strcmp
    
    err = 0;
    
catch %main catch
    err = 1;
end

%kill excel
if ~isempty(Excel)
    invoke(Excel,'Quit');
    delete(Excel);
end

if err error(['MainCatch: ' lasterr]); end
%---END MAIN---

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% put 0 as startrow to find lastmost record regardless of sections
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [res,hd,eot,sec]=SeekToLastRow(wksht, startrow)
maxempty    = 6;
first       = 1;
lastmost    = 0; %search the lastmost row if not then will return first feader found after the startrow and the section start position
hd  = [];
res = 0;
eot = 0;    %end of table flag
sec ='';

if startrow==0
    startrow=1;
    lastmost=1;
end

empty = 0;

for r=startrow:65535
    checkCell = get(wksht,'Cells',r,1);
    if isempty(checkCell.formula)
        if empty==0 
            res     = r; 
            first   = 1;
        end %possibly the new appendpos
        empty = empty+1;
        if empty>=maxempty
            eot = 1;
            break;
        end
    else
        if lastmost==0 & empty>0 break; end
                
        empty = 0;
        if first==1
            if r>1 %header
                checkCell = get(wksht,'Cells',r,1);
                sec = checkCell.formula;
                r=r+1; %skipping header for sections after the first one
            end 
            for c=1:1000 %check the row
                checkCell = get(wksht,'Cells',r,c);
                if isempty(checkCell.formula) break; end
            end
            r2 = get(wksht,'Range',eR(r,1,r,c-1));
            hd = r2.formula;
            first = 0;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% just compare arrays of strings for size and content
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res=ArraysAreEqual(a,b)
sza = size(a,2);
szb = size(b,2);
res = 1;
if sza~=szb 
    res=0;
else %compare headers
    for i=1:sza
        if strcmp(a{i}, b{i})==0
            res=0;
            break;
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% form excel cell address
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function txt=eC(r,c)
%excel column addressing notation
exRow={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','aa','ab','ac','ad','ae','af','ag','ah','ai','aj','ak','al','am','an','ao','ap','aq','ar','as','at','au','av','aw','ax','ay','az','ba','bb','bc','bd','be','bf','bg','bh','bi','bj','bk','bl','bm','bn','bo','bp','bq','br','bs','bt','bu','bv','bw','bx','by','bz','ca','cb','cc','cd','ce','cf','cg','ch','ci','cj','ck','cl','cm','cn','co','cp','cq','cr','cs','ct','cu','cv','cw','cx','cy','cz','da','db','dc','dd','de','df','dg','dh','di','dj','dk','dl','dm','dn','do','dp','dq','dr','ds','dt','du','dv','dw','dx','dy','dz','ea','eb','ec','ed','ee','ef','eg','eh','ei','ej','ek','el','em','en','eo','ep','eq','er','es','et','eu','ev','ew','ex','ey','ez','fa','fb','fc','fd','fe','ff','fg','fh','fi','fj','fk','fl','fm','fn','fo','fp','fq','fr','fs','ft','fu','fv','fw','fx','fy','fz','ga','gb','gc','gd','ge','gf','gg','gh','gi','gj','gk','gl','gm','gn','go','gp','gq','gr','gs','gt','gu','gv','gw','gx','gy','gz','ha','hb','hc','hd','he','hf','hg','hh','hi','hj','hk','hl','hm','hn','ho','hp','hq','hr','hs','ht','hu','hv','hw','hx','hy','hz','ia','ib','ic','id','ie','if','ig','ih','ii','ij','ik','il','im','in','io','ip','iq','ir','is','it','iu','iv'};
txt= [exRow{c} int2str(r)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% form excel range address
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function txt=eR(r,c,r1,c1)
exRow={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','aa','ab','ac','ad','ae','af','ag','ah','ai','aj','ak','al','am','an','ao','ap','aq','ar','as','at','au','av','aw','ax','ay','az','ba','bb','bc','bd','be','bf','bg','bh','bi','bj','bk','bl','bm','bn','bo','bp','bq','br','bs','bt','bu','bv','bw','bx','by','bz','ca','cb','cc','cd','ce','cf','cg','ch','ci','cj','ck','cl','cm','cn','co','cp','cq','cr','cs','ct','cu','cv','cw','cx','cy','cz','da','db','dc','dd','de','df','dg','dh','di','dj','dk','dl','dm','dn','do','dp','dq','dr','ds','dt','du','dv','dw','dx','dy','dz','ea','eb','ec','ed','ee','ef','eg','eh','ei','ej','ek','el','em','en','eo','ep','eq','er','es','et','eu','ev','ew','ex','ey','ez','fa','fb','fc','fd','fe','ff','fg','fh','fi','fj','fk','fl','fm','fn','fo','fp','fq','fr','fs','ft','fu','fv','fw','fx','fy','fz','ga','gb','gc','gd','ge','gf','gg','gh','gi','gj','gk','gl','gm','gn','go','gp','gq','gr','gs','gt','gu','gv','gw','gx','gy','gz','ha','hb','hc','hd','he','hf','hg','hh','hi','hj','hk','hl','hm','hn','ho','hp','hq','hr','hs','ht','hu','hv','hw','hx','hy','hz','ia','ib','ic','id','ie','if','ig','ih','ii','ij','ik','il','im','in','io','ip','iq','ir','is','it','iu','iv'};
txt = [exRow{c} int2str(r) ':' exRow{c1} int2str(r1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert cell array to array of text string 
% (numbers kept untouched) 
% focus on 2D matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function arrout = eConvert(celar)
sz = size(celar,2);
for c=1:sz
    val = celar(c);
    if ischar(val{1})
        arrout{c}=val{1};
    else
        val = val{1};
        n = size(val,1);
        m = size(val,2);
        if m==1 & n==1
            strout = val;
        else
            strout = '';
            for j=1:n
                for i=1:m
                    [sval,e] = sprintf('%.4f',val(j,i));
                    strout = [ strout sval ];
                    if i<m strout = [ strout ' ']; end
                end
                if j<n strout = [ strout ' ; ']; end
            end
        end
        arrout{c}=strout;
    end
end
