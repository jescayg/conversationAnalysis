% Based on https://blogs.mathworks.com/loren/2017/09/21/math-with-words-word-embeddings-with-matlab-and-text-analytics-toolbox/#34dd85a0-738d-40e4-8a83-13d3e4d3c536


clear
close all
%Loading in the database of the words
filename = "glove.6B.300d";
if exist(filename + '.mat', 'file') ~= 2
    emb = readWordEmbedding(filename + '.txt');
    save(filename + '.mat', 'emb', '-v7.3');
else
    load(filename + '.mat')
end

if exist('nouns.mat','file') ~= 2
    url = 'http://www.desiquintans.com/downloads/nounlist/nounlist.txt';
    nouns = webread(url);
    whos nouns;
    nouns = split(nouns);
    whos nouns;
    save('nouns.mat','nouns');
else
    load('nouns.mat')
end
nouns(~ismember(nouns,emb.Vocabulary)) = [];
%disp(nouns)
vec = word2vec(emb,nouns);
%disp(vec)
%rng('default'); % for reproducibility
%xy = tsne(vec);
%tlab=textscatter(xy,nouns);

%Loading in the conversation text data 

if exist('convo1.mat','file') ~= 2 
    filetext = fileread('convo1.txt');
    convo1 = erasePunctuation(filetext);
    % Erases punctuation 
    convo1 = split(convo1); 
    % Splits the text at whitespaces creating an array of words
    save('convo1.mat','convo1');
else
    load('convo1.mat')
end
if exist('convo2.mat','file') ~= 2 
    filetext = fileread('convo2.txt');
    convo2 = erasePunctuation(filetext);
    convo2 = split(convo2);
    save('convo2.mat','convo2');
else
    load('convo2.mat')
end
if exist('convo3.mat','file') ~= 2 
    filetext = fileread('convo3.txt');
    convo3 = erasePunctuation(filetext);
    convo3 = split(convo3);
    save('convo3.mat','convo3');
else
    load('convo3.mat')
end
% if exist('sentences.mat','file') ~= 2 
%     fid = fopen('Sentences.txt','rt');
%     sentences = string.empty();
%     count =0;
%     while true
%         thisline = fgetl(fid);
%         disp(thisline)
%         
% %         sentences{size} = [convertCharsToStrings(thisline)];
% %         sentences{size} = erasePunctuation(sentences{size});
%         
%         sentences{count} = [erasePunctuation(thisline)];
%         
%         sentences{count} = split(sentences{count});
%         count = count + 1;
%         if ~ischar(thisline); break; end  %end of file
%       
%         
%             %now check whether the string in thisline is a "word", and store it if it is.
%             %then
%     end
%     fclose(fid);
%     disp(sentences);
%     save('sentences.mat','sentences');
% else
%     load('sentences.mat')
% end

% filetext = fileread('test1.txt');
% test1 = erasePunctuation(filetext);
% test1 = split(test1); 
% test1(~ismember(test1,emb.Vocabulary)) = [];
% Tvec = word2vec(emb,test1);
% filetext = fileread('test2.txt');
% test2 = erasePunctuation(filetext);
% test2 = split(test2); 
% test2(~ismember(test2,emb.Vocabulary)) = [];
% T2vec = word2vec(emb,test2);
% 
% txy = tsne(Tvec);
% tlab=textscatter(txy,Tvec);
% get(tlab)
% set(tlab,'MarkerCOlor',[1,0,0])
% hold on
% t2xy = tsne(T2vec);
% tlab2=textscatter(t2xy,T2vec);
% get(tlab2)
% set(tlab2,'MarkerCOlor',[1,0,0])
% hold on
% prompt = 'ready to view the next graph';
% x = input(prompt,'s');
% close all

%Create list of the conversations
list= {convo1,convo2,convo3};
disp(list)
 delete_repetition(list);
%Creating vectors of each conversation
convo1(~ismember(convo1,emb.Vocabulary)) = [];
vec1 = word2vec(emb,convo1);

convo2(~ismember(convo2,emb.Vocabulary)) = [];
vec2 = word2vec(emb,convo2);

convo3(~ismember(convo3,emb.Vocabulary)) = [];
vec3 = word2vec(emb,convo3);

rng('default'); % for reproducibility

%Conversation 1 text scatter Graph
xy = tsne(vec1);
tlab=textscatter(xy,convo1);
get(tlab)
set(tlab,'MarkerCOlor',[1,0,0])
hold on


xy2 = tsne(vec2);
tlab2=textscatter(xy2,convo2);
get(tlab2)
set(tlab2,'MarkerCOlor',[0,1,0])
hold on


xy3 = tsne(vec3);
tlab3=textscatter(xy3,convo3);
get(tlab3)
set(tlab3,'MarkerCOlor',[0,0,1])

prompt = 'Ready to view the conhull? ';
value = input(prompt,'s');

%Text scatter

%Convhulls

close all
% Convhull for conversation 1
K1 = convhull(double(xy));
plot(xy(:,1),xy(:,2),'-r',xy(K1,1),xy(K1,2),'-r',xy(1,1),xy(2,1),'or') 
hold on

% Convhull for conversation 2

K2= convhull(double(xy2));
plot(xy2(:,1),xy2(:,2),'-b',xy2(K2,1),xy2(K2,2),'-b',xy2(1,1),xy2(2,1),'or')
hold on
% Convhull for conversation 3
K3= convhull(double(xy3));
plot(xy3(:,1),xy3(:,2),'-g',xy3(K3,1),xy3(K3,2),'-g',xy3(1,1),xy3(2,1),'or')


%Creating an array list of stopwords
function stopwords=get_stopwords()

end


%Creating a recursive function 

function delete_repetition(list)
   for i=0:length(list)
       for j=1:length(list)
           word = strsplit(list{i});
           for ii=1:length(word)
               list{j}=erase(list{j},word(ii));
           end
       end
   end
 end
