class PostsController < ApplicationController
  # GET /posts

  # GET /posts.json
  #this is to check the sessions.
    before_filter :authorize, :except => :search
   #This method is used to display all the posts.So here we take the Weight which we gave to each post.
  #This weight will be used in displaying the posts.
  def index
    @postsByWeight=Post.order("weight DESC")
      @posts = Post.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
  end

   #This method is used for voting the Posts/Replys.Here we try to find the post in Db based on the postid selected for voting
   #Then we store the post_id,user_id into vote table.Then we update the numberofVotes column then increase the weight using metrics
   # Then we redirect to post page if there exists any errors we report the error in post index page.
  def vote
    @post = Post.find(params[:id])
    respond_to do |format|
        @foundVote = Vote.new
        @foundVote.post_id = params[:id]
        @foundVote.user_id = User.find_by_userName(session[:userName]).id
        @foundVote.numberOfVotes = 0

        #if @foundVote !='nil'
         if @foundVote.update_attributes(params[:numberOfVotes])
          metric(@foundVote.post_id)
          format.html { redirect_to posts_path, notice: 'Vote successfully submitted.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          puts "error"
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
  end

    #This method is used to create teh reply for the posts.Where we take the user data from User table and update it in post table.
    #With the reply and parentpostId = postId for which the reply is given  in Posts table.
  def createreply
    @user = User.find_by_userName(session[:userName])
    @post = Post.new(:user_id => @user.id, :postString => params[:replyContent], :parentPostID => params[:parentPostID])

    respond_to do |format|

      if @post.save
          format.html { redirect_to Post.find(params[:parentPostID]), notice: 'Post was successfully created.' }
          format.json { render json: Post.find(params[:parentPostID]), status: :created, location: Post.find(params[:parentPostID]) }
      else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def reply
    @post = Post.find_by_id(params[:id])
  end

  # GET /posts/search
    #This method is used for searching the posts based on User/Content of post.
    #Here if the search is based on "searchContent" we cehck all the posts with this content and put in posts array.
    #This post array(not nil) is then sent to the posts index page
    #Here if the search is based on "searchUser" we check all the posts with this user as owner and put in posts array.
    #This post array(not nil) is then sent to the posts index page
  def search
    if((params[:searchContent] != nil) || (params[:selectSearch] == "searchContent"))
      @posts = Array.new
      Post.all.each do
        |post|
        if (post.postString.index(params[:s]))
          @posts << post
        end
      end

      if(@posts==nil)
      else
        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @posts }
        end
      end

    elsif((params[:searchContent] != nil) || (params[:selectSearch] == "searchUser"))
      @posts = Array.new
      @user = User.find_by_userName(params[:s])

      if(@user != nil)
        Post.all.each do
          |post|
          if (post.user_id == @user.id)
            @posts << post
          end
        end

        if(@posts==nil)
        else
          respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @posts }
          end
        end
      end
    end
  end

  # GET /posts/1
  # GET /posts/1.json
    # This method is to display all the posts with their replies.
  def show
    @childPosts = Array.new
    @childPosts << Post.find(params[:id])

    Post.all.each do |post|
      if(post.parentPostID.to_s() == params[:id])
        if(post.parentPostID != post.id)
          @childPosts << post
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @childPosts }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end


  # POST /posts
  # POST /posts.json
    #This method is used to create the new posts and we give a default 50 weight for each post.
  def create
    @post = Post.new(params[:post])
    @user = User.find_by_userName(session[:userName])

    respond_to do |format|
      if @post.save
        @post.parentPostID = @post.id

        #update the parent post id
        @post.update_attribute("parentPostID",@post.parentPostID)
        @post.update_attribute("weight",50)
                metric(@post.id)

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
    #Thsi method is for updating the posts
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
    #this method is for deleting the posts i.e delating all the replies and votes related to this post as well.
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    parentVotes = Array.new
    parentVotes = Vote.find(:all, :conditions => ["post_id = ?", @post.id])

    #remove the vote for the parent post
    parentVotes.all do |parentVote|
      parentVote.destroy
    end

    #remove the child posts
    @childPosts = Post.find(:all, :conditions => ["parentPostID = ?", params[:id]])
    @childPosts.all do |childPost|
      childPost.destroy
    end

    #remove the votes
    @childPosts.all do |childPost|
      votes = Array.new
      votes = Vote.find(:all, :conditions => ["post_id = ?", childPost.id])
      votes.all do |vote|
        vote.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

     #Thsi metric method is used to give a weight to each posts(based on the date it is created,no.of votes it got)
     # Here we check the diff with current date and then the no.of votes for this post.
    # later the diff is subtracted from the default value(50 given intially) plus the votes.
    #And finally updating this weight in the Weight column of the Posts table.

    def metric(postID)
        posted = Date.new
       postArray=Post.find(postID)
        ppostID=postArray.parentPostID
        posted=postArray.created_at.to_date
        diff=(Date.today-posted).to_i
        nVotes=0
        nVotes= Vote.find_all_by_post_id(postID).length

        weight=50-diff+nVotes
        upPost=Post.find(ppostID)
        upPost.update_attribute(:weight,weight)
    end

end