class ApplicationController < ActionController::Base
  protect_from_forgery
  private

  #This method is to check whether teh session exists for the user to see the required page/screen
  #If not we redirect to the login screen
  #Ex:When a user randomly try to open certain link of page (http://127.0.0.1:3000/posts)
    def authorize
    if(session[:userName]!='nil')
      unless User.find_by_userName(session[:userName])
      redirect_to(:controller => "logins" , :action => "index" )
    #if(params[:name]!='nil')
      #redirect_to(:controller => "logins", :action => "index")
     end
    end
   end
end
