class Milestone
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String
  property :description, Text
  property :expected_at, Date

  belongs_to :project

  has n, :tickets
  before :destroy , :destroy_ticket

  def destroy_ticket
    tickets.each{|t| t.destroy}
  end

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
    100.0 * ticket_closed_count / tickets.size
  end

  def ticket_open_count
    tickets.count(:state_id.not => State.closed.map{|s| s.id})
  end

  def ticket_open
    tickets.all(:state_id.not => State.closed.map{|s| s.id})
  end

  def ticket_closed_count
    tickets.count(:state_id => State.closed.map{|s| s.id})
  end

  def tag_counts
    Tagging.all(:taggable_id => tickets.map(&:id), :taggable_type => 'Ticket').group_by(&:tag_id)
  end


end
