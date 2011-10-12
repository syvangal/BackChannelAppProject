class LoginsController < ApplicationController
  # GET /logins
  # GET /logins.json
  #This method is to show the login screen when redirected with sessions cleared.
  def index
    session[:userName] = nil
    session[:role]= nil
    @adminCheck = User.find_by_role("admin")
    if(@adminCheck == nil)
      puts "inside the if"
    @admin=User.new(:userName=> "adminaccount", :password=>"admin123",:unityId=>"admin123",:emailAddress=>"admin@gmail.com",:role=>"admin")
    @admin.save
      end
  end

  # POST /logins
  # POST /logins.json
  #This method is for Authenticating the User, First we check whether the User exists with the username entered in login page.
  #If there isnt any record found we are redirecting the User to Login screen with a proper error msg.
  #If a record exists whether the password matches with the password stored in DB and the role as well.
  #On success we redirect to the Posts/index if not then Login screen.
  def create
  @user= User.find_by_userName(params[:name])
  if(@user == nil)
      flash[:notice] = "Incorrect Username/Password"
       redirect_to(:controller => "logins", :action => "index")

    else if(params[:password]!= 'nil' && @user.password == params[:password] && @user.role == "user")
      session[:userName]=@user.userName
      session[:id]=@user.id
      session[:role]="user"
      redirect_to(:controller => "posts", :action => "index")
    else if(params[:password]!= 'nil' && @user.password == params[:password] && @user.role == "admin")
        session[:userName]=@user.userName
      session[:id]=@user.id
      session[:role]="admin"
      redirect_to(:controller => "posts", :action => "index")
     else
      flash[:notice] = "Incorrect Username/Password"
      redirect_to(:controller => "logins", :action => "index")
      end
    end
    end

 # This method is to edit, which we are not gonna use here.
  def edit
     #@logins = Login.all
     session[:userName] = nil
       session[:id]= nil
       redirect_to(:controller => "logins", :action => "index")
    #logout();
  end

  #This method is for signout where we clear the sessions.
    def signOut
       session[:userName] = nil
       session[:id]= nil
       session[:role]= nil
       redirect_to(:controller => "logins", :action => "index")

    end
    end


end
