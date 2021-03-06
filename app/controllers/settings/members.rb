module Settings
  class Members < Application
    # provides :xml, :yaml, :js
    
    before :project_admin_authenticated
  
    def index(project_id)
      @members = Member.all(:project_id => project_id)
      @title = "Members"
      display @members
    end
  
    def show(id)
      @member = Member.get(id)
      raise NotFound unless @member
      @title = "member #{@member.user.login}"
      display @member
    end
  
    def new
      only_provides :html
      @member = Member.new
      @title = "new member"
      display @member
    end
  
    def create(member)
      @member = Member.new(member)
      @member.function_id = Function.first(:name => 'Developper').id
      @member.project_id = @project.id
      if @member.save
        redirect url(:project_settings_members, @project), :message => {:notice => "Member was successfully created"}
      else
        message[:error] = "Member failed to be created"
        render :new
      end
    end
  
    private

    def project_admin_authenticated
      @project = Project.get(params[:project_id])
      raise Unauthenticated unless session.user
      return true if session.user.global_admin?
      member = @project.members.first(:user_id => session.user.id)
      raise Unauthenticated if member.nil?
      raise Unauthenticated unless member.project_admin?
    end

  end # Members
end # Settings
