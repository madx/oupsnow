module Merb
  module TicketsHelper

    def update_field(prop)
      "#{property_update(prop)} is change from '#{old_field(prop)}' to '#{new_field(prop)}'"
    end

    def sort_by(property)
      if params[:sort_by] == property
        {:sort_by => property, :order => (params[:order] == 'asc' ? 'desc' : 'asc')}
      else
        {:sort_by => property, :order => 'asc'}
      end
    end

    def property_update(prop)
      case prop[0]
      when :state_id
        "Status"
      when :tag_list
        "Tag"
      when :member_assigned_id
        "Responsible"
      when :title
        "Title"
      when :priority_id
        "Priority"
      when :milestone_id
        "Milestone"
      end
    end

    def old_field(prop)
      transform_field(prop[0], prop[1])
    end

    def new_field(prop)
      transform_field(prop[0], prop[2])
    end

    def transform_field(state, field)
      return "" if field.nil?
      case state
      when :state_id
        State.get(field).name
      when :tag_list
        field
      when :member_assigned_id
        m = User.get(field)
        m ? m.login : ""
      when :title
        field
      when :priority_id
        p = Priority.get(field)
        p ? p.name : ""
      when :milestone_id
        m = Milestone.get(field)
        m ? m.name : ""
      end
    end

  end
end # Merb
