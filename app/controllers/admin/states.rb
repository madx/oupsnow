module Admin
  class States < Application
    # provides :xml, :yaml, :js
    
    before :ensure_authenticated
    before :need_admin
  
    def index
      @states = State.all
      display @states
    end
  
    def show(id)
      @state = State.get(id)
      raise NotFound unless @state
      display @state
    end
  
    def new
      only_provides :html
      @state = State.new
      display @state
    end
  
    def edit(id)
      only_provides :html
      @state = State.get(id)
      raise NotFound unless @state
      display @state
    end
  
    def create(state)
      @state = State.new(state)
      if @state.save
        redirect resource(:admin, :states), :message => {:notice => "State was successfully created"}
      else
        message[:error] = "State failed to be created"
        render :new
      end
    end
  
    def update(id, state)
      @state = State.get(id)
      raise NotFound unless @state
      if @state.update_attributes(state)
         redirect resource(:admin, @state)
      else
        display @state, :edit
      end
    end

    def update_all(closed)
      closed.each do |k, v|
        s = State.get(k)
        s.closed = (v == "1".to_s)
        s.save
      end
      redirect resource(:admin, :states), :message => 'All states updated'
    end
  
    def destroy(id)
      @state = State.get(id)
      raise NotFound unless @state
      if @state.destroy
        redirect resource(:admin, :states)
      else
        raise InternalServerError
      end
    end
  
  end # States
end # Admin
