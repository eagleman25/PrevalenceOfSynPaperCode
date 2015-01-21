
% some clustering would be good.  so what we need
% are a representations of the letter set, and then a distance metric, and
% then a clustering method.
% in this case let the representation be the color category
% the distance is the number of letters with different matches (or 26 - num
% matches).  this is the hamming distance

% our data
X=labels.eagleman;

% kmedoids allows us to use the hamming distance as our distance function
dist = 'hamming';

% kmedoids also allows us to ignore nans so let's turn no matches back into
% nans since we don't really want to cluster by unmatched letters.  we
% coded no matches as 11 so
% X(find(labels.eagleman==11))=nan;


% In the paper we showed an example where we used 9 as the number of
% clusters.  since the clustering you get will vary on each iteration, it
% may be necessary to run this loop a few times to get the magnet cluster
% to show up clearly. to see the clustering for many values of k  replace
% the beginning of this bit with 
% for k=4:20 or whatever numbers of clusters you like
    for K=9
        %     make a figure
        figure('name', ['clusters where K = ' num2str(K)], 'Color', [1 1 1],...
        'Position',get(0,'ScreenSize'));
        %     compute k means solution of size k
        [IDX, C, SUMD, D] =kmedoids(X,K,'distance',dist);
        %     IDX is number of cluster each subject belongs to and will range from
        %     1:k
        %    C is the center of each cluster in 26 d space (so C is Kx26)
        %     SUMD is the sum of all the distances in a cluster to its center
        %    D is the distance of every point to every center and is 6588 x K
        
        %     compute a fit metric for this k
        %    cna use the average mahalanobis distance with the following algorithm
        %    X is your data
        %    C are your cluster Centers
        %    going to use Y=p/2 where p is dimensionality of data
        %    the justification for this would take me a while
        
        %    the algorighm is
        %    1.  given X generate K clusters
        %    2.  compute a distortion metric d which is
        %     this turns out to be hard!  need to spend more time.
        %  for now let's try using D
        
        
        %   set up subplot of kmeans clusters
        [nrows ncols] = subplotsize(K);
        %     for each cluster
        for i=1:K
            % make a figure showing the letter color matches of its members
            subplot(nrows,ncols,i);
            imagesc(p_rgb(find(IDX==i),:,:));
            ylabel('SUBJECTS');
            xlabel('LETTERS');
            set(gca,'XTick',[1:26],'XTickLabel',{letters} );
            % 'YDir','normal');
            box off;
            
        end
        
    end


% how many clusters should we use.  one way to think about it is that
% clustering reduces the data to our number of clusters.  we can compute
% the distance between the clustering and our data for each value of k
% (number of clusters) and see where we stop getting better.  obviously
% when k is the same as the number of subjects that is best, but you can
% get pretty close with around 9
% % let's try to find an optimal K
for K=1:20
    
    %     compute k medoids solution with k clusters
    [IDX, C, SUMD, D] =kmedoids(X,K,'distance',dist);
% get mean distance of every subject to cluster center
    Kdists(K)=mean(SUMD);

end

% make a plot of average distance from cluster center
% 
figure('Name','average distance from center as a function of K','Color',[1 1 1]);
plot(4:length(Kdists),abs(diff(Kdists(3:end))),'ro');
box off;
xlabel('number of clusters'); ylabel('decrease in average distance with additional cluster');

% 9 clusters seems a good comprimise between data explained, number of
% clusters and an uncluttered figure



% a reviewer asks about the overlap between the clustering analysis and the
% template approach.  while this is not the goal of the analysis we could
% compute how well the two match up.  since clustering is not deterministic
% we can run it many times and find out the average overlap over many
% iterations


% number of times to do k medoids for a given k
% for paper did this 1000 times but that takes a while
numrpts = 25;
% for some k
k=9;

% variable to tell us proportion of cluster inside template
overlapt = zeros(k*numrpts,1);

% percent of template inside cluster
overlapc = overlapt;

cntr=1;
%     do clustering numrpts times
   for r=1:numrpts
        [IDX, C, SUMD, D] =kmedoids(X,K,'distance',dist);
%         find number of magnet synesthetes in each cluster
    for o=1:k
%         for each cluster find number of mags
        nmagsincluster =length(find(syntype(find(IDX==o))==2));
%      get proportion of template that is in the cluster
        overlapt(cntr)=nmagsincluster/length(find(syntype==2));
%         get proprtion of cluster that is in the template
        overlapc(cntr)=nmagsincluster/length(find(IDX==o));
        cntr=cntr+1;
    end
   end
    
   figure('Name',['percent of 400 syns found in a cluster where k= ' num2str(k) ...
       ' ' num2str(numrpts) ' iterations'],'Color', [1 1 1]);
   
   [counts bins]=hist(overlapt,.05:.1:.95);
   hist(overlapt,.05:.1:.95);
   ylabel('# of clusters');
   xlabel('% of 400 syns inside cluster');
   box off;
   
% proportion of clusters with fewer than 20% of magnet syns


fprintf('%g of clusters had less than 10 percent of magnet syns\n',sum(counts(1))/sum(counts(:)))

fprintf('%g of clusters had more than 90 percent of magnet syns\n',sum(counts(9:end))/sum(counts(:)))

fprintf('%g of clusters had between 10 and 90 percent of magent synesthetes\n',sum(counts(2:8))/sum(counts))








%