class Milestone
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :description, Text
  property :expected_at, Date

  belongs_to :project

  has n, :tickets

  def write_event_create(user)
    Event.create(:eventable_class => self.class,
                 :eventable_id => id,
                 :user_id => user.id,
                 :event_type => :created,
                 :project_id => project_id)
  end

  alias_method :title, :name

  def percent_complete
    return 0 if tickets.empty?
    100.0 * ticket_open_count / tickets.size
  end

  def ticket_open_count
    tickets.count(:state_id.not => State.first(:name => 'closed').id)
  end

  def ticket_open
    tickets.all(:state_id.not => State.first(:name => 'closed').id)
  end

  def ticket_closed_count
    #TODO: define a closed state to all state
    tickets.count(:state_id => State.first(:name => 'closed').id)
  end


end
