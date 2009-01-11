class Manage::VotesController < Manage::ManageController
  
  Vote_PerPage = 20

  Rand_Vote_Perpage = 10

  Max_Friend_Count = 50
  # GET /votes
  # GET /votes.xml
  def index
    @votes = Vote.paginate(:page => params[:page]||1,:per_page => Vote_PerPage,:conditions => "user_id =#{current_user.id}")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  def random_votes
    @votes = Vote.paginate(:page => params[:page]||1,:per_page => Rand_Vote_Perpage,:order => 'id')
    render :action => :index
  end

  def friend_votes
    friends = Friend.find(:all,:conditions => "user_id=#{current_user.id}",:limit => Max_Friend_Count)
    @votes = if friends.blank?
      []
    else
      Vote.paginate(:page => params[:page]||1,:per_page => Vote_PerPage,
        :conditions => "user_id in (#{friends.map(&:id).join(',')})")
    end
    render :action => :index
  end

  # GET /votes/1
  # GET /votes/1.xml
  def show
    @vote = Vote.find(params[:id])
    @vote_options = VoteOption.find(:all,:conditions => "voter_id=#{@vote.id}")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end
  
  def post_vote
    if params[:vote_values].blank?
      flash[:notice] = '请至少选择一个候选项'
      @vote = Vote.find(params[:id])
      @vote_options = VoteOption.find(:all,:conditions => "voter_id=#{@vote.id}")
      render :action => :show
      return false;
    end
    vote_id,user_id = params[:id],current_user.id
    params[:vote_values].each do |vote_value|
      UserVote.create(:voter_id => user_id,:vote_value => vote_value,:vote_id => vote_id)
    end
    redirect_to :action => :show
  end

  # GET /votes/new
  # GET /votes/new.xml
  def new
    @vote = Vote.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.xml
  def create
    @vote = Vote.new(params[:vote])
    @vote.user_id  = current_user.id
    if @vote.save
      @vote.vote_options.each do |option_name|
        next if option_name.blank?
        VoteOption.create(:title => option_name,:voter_id => @vote.id)
      end
      flash[:notice] = 'Vote was successfully created.'
      redirect_to :action => :index
    else
      render :action => "new"
    end
  end

  # PUT /votes/1
  # PUT /votes/1.xml
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        flash[:notice] = 'Vote was successfully updated.'
        format.html { redirect_to(@vote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(votes_url) }
      format.xml  { head :ok }
    end
  end
end
