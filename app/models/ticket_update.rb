class TicketUpdate
  include DataMapper::Resource
  
  property :id, Serial
  property :properties, Json
  property :description, Text
  property :created_at, DateTime

  belongs_to :ticket


end
